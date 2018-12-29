#![feature(cell_update)]
use std::cmp::Ordering;
use std::io::Read;
use std::fs::File;
use std::collections::HashSet;
use std::cell::Cell;
use std::mem;

#[derive(Debug, Clone)]
struct UnitStack<'a> {
    units: Cell<i32>,
    hp: i32,
    attack: i32,
    init: i32,
    attack_kind: &'a str,
    immune_to: HashSet<&'a str>,
    weak_to: HashSet<&'a str>,
    selected_target: (bool, u32),
    id: u32
}

struct IterMerge<T: Iterator, F: FnMut(&T::Item, &T::Item) -> Ordering> {
    a: T,
    b: T,
    temp_a: Option<T::Item>,
    temp_b: Option<T::Item>,
    cmp_fn: F
}

impl<T: Iterator, F: FnMut(&T::Item, &T::Item) -> Ordering> IterMerge<T, F> {
    fn new(a: T, b: T, cmp_fn: F) -> IterMerge<T, F> {
        IterMerge {
            a, b, cmp_fn,
            temp_a: None,
            temp_b: None
        }
    }
}

impl <T: Iterator, F: FnMut(&T::Item, &T::Item) -> Ordering> Iterator for IterMerge<T, F> {
    type Item = T::Item;
    fn next(&mut self) -> Option<Self::Item> {
        if self.temp_a.is_none() {
            let ta = self.a.next();
            if ta.is_none() {
                if self.temp_b.is_some() {
                    return self.temp_b.take();
                }
                return self.b.next();
            } else {
                self.temp_a = ta;
            }
        }
        if self.temp_b.is_none() {
            let tb = self.b.next();
            if tb.is_none() {
                return self.temp_a.take();
            } else {
                self.temp_b = tb;
            }
        }
        if let Some(ta) = &self.temp_a {
            if let Some(tb) = &self.temp_b {
                if (self.cmp_fn)(ta, tb) == Ordering::Less {
                    return self.temp_b.take();
                } else {
                    return self.temp_a.take();
                }
            }
        }
        unreachable!();
    }
}

fn damage_to_stack(atk: &UnitStack, def: &UnitStack) -> i32 {
    if def.immune_to.contains(atk.attack_kind) {
        0
    } else if def.weak_to.contains(atk.attack_kind) {
        eff_power(atk) * 2
    } else {
        eff_power(atk)
    }
}
fn eff_power(u: &UnitStack) -> i32 {
    u.units.get() * u.attack
}

fn unitstack_attack_order(a: &UnitStack, b: &UnitStack) -> Ordering {
    eff_power(a).cmp(&eff_power(b)).then(a.init.cmp(&b.init)).reverse()
}


fn run_combat(mut imms: Vec<UnitStack>, mut inf: Vec<UnitStack>, boost: i32) -> (i32, i32) {
    for stack in &mut imms {
        stack.attack += boost;
    }
    while !inf.is_empty() && !imms.is_empty() {
        inf.sort_unstable_by(unitstack_attack_order);
        imms.sort_unstable_by(unitstack_attack_order);
        let mut taken_target = HashSet::new();
        for stack in &mut inf {
            if let Some(target) = imms.iter()
                .filter(|x| !taken_target.contains(&x.id))
                .filter(|x| !x.immune_to.contains(stack.attack_kind))
                .max_by(|a, b| {
                let o = damage_to_stack(stack, a).cmp(&damage_to_stack(stack, b));
                let o = o.then(eff_power(a).cmp(&eff_power(b)));
                o.then(a.init.cmp(&b.init))
            }) {
                stack.selected_target = (true, target.id);
                taken_target.insert(target.id);
            } else {
                stack.selected_target = (true, 0);
            }
        }
        for stack in &mut imms {
            if let Some(target) = inf.iter()
                .filter(|x| !taken_target.contains(&x.id))
                .filter(|x| !x.immune_to.contains(stack.attack_kind))
                .max_by(|a, b| {
                let o = damage_to_stack(stack, a).cmp(&damage_to_stack(stack, b));
                let o = o.then(eff_power(a).cmp(&eff_power(b)));
                o.then(a.init.cmp(&b.init))
            }) {
                stack.selected_target = (false, target.id);
                taken_target.insert(target.id);
            } else {
                stack.selected_target = (true, 0);
            }
        }

        
        imms.sort_unstable_by(|a, b| a.init.cmp(&b.init).reverse());
        inf.sort_unstable_by(|a, b| a.init.cmp(&b.init).reverse());
        let mut stalemate = true;
        for stack in IterMerge::new(imms.iter(), inf.iter(), |a, b| a.init.cmp(&b.init)) {
            if stack.units.get() <= 0 {
                continue;
            }
            if stack.selected_target.1 == 0 {
                continue;
            }
            let (stg, sti) = stack.selected_target;
            let mut victim = unsafe { mem::uninitialized() };
            for vct in if stg { &imms } else { &inf } {
                if vct.id == sti {
                    victim = vct;
                }
            }
            victim.units.update(|f| {
                let utk = damage_to_stack(&stack, victim) / victim.hp;
                if utk > 0 {
                    stalemate = false;
                }
                f - utk
            });
        }
        imms = imms.into_iter().filter(|x| x.units.get() > 0).collect();
        inf = inf.into_iter().filter(|x| x.units.get() > 0).collect();
        if stalemate {
            break;
        }
    }
    (imms.iter().map(|x| x.units.get()).fold(0, |a, b| a + b), inf.iter().map(|x| x.units.get()).fold(0, |a, b| a + b))
}

fn main() {
    let mut input = String::new();
    File::open("in.txt").unwrap().read_to_string(&mut input).unwrap();
    let input = input.split("\n");  
    let mut inf = Vec::new();
    let mut imms = Vec::new();
    let mut vis_imms = true;
    let mut id = 0;
    for line in input {
        if line == "" {
            vis_imms = false;
            continue;
        }
        if line == "Immune System:" || line == "Infection:" {
            continue;
        }
        id += 1;
        let mut stack = UnitStack {units: Cell::new(0),
            hp: 0,
            attack: 0, 
            init: 0, 
            attack_kind: "", 
            immune_to: HashSet::new(), 
            weak_to: HashSet::new(),
            selected_target: (false, 0),
            id
        };
        let words = line.split(" ").collect::<Vec<&str>>();
        stack.units = Cell::new(words[0].parse().unwrap());
        stack.hp = words[4].parse().unwrap();
        let mut focus = 7;
        if words[focus] == "(weak" {
            focus += 2;
            loop {
                let wd = words[focus];
                stack.weak_to.insert(&wd[0..(wd.len() - 1)]);
                focus += 1;
                if wd.as_bytes()[wd.len() - 1] != b',' {
                    break;
                }
            }
        }
        if words[focus] == "(immune" || words[focus] == "immune" {
            focus += 2;
            loop {
                let wd = words[focus];
                stack.immune_to.insert(&wd[0..(wd.len() - 1)]);
                focus += 1;
                if wd.as_bytes()[wd.len() - 1] != b',' {
                    break;
                }
            }
        }
        stack.init = words[words.len() - 1].parse().unwrap();
        stack.attack = words[words.len() - 6].parse().unwrap();
        stack.attack_kind = words[words.len() - 5];
        if vis_imms {
            imms.push(stack);
        } else {
            inf.push(stack);
        }
    }

    for i in 1.. {
        let (immhp, infhp) = run_combat(imms.clone(), inf.clone(), i);
        if immhp > 0 && infhp == 0 {
            println!("{}", immhp);
            break;
        }
    }
}
