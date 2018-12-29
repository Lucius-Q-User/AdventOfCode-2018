program part1
  implicit none
  integer, parameter :: lun = 10
  integer :: nlines, io, i, minx, miny, maxx, maxy, clv, cli, dist, x, y
  integer, allocatable, dimension(:) :: coord_x, coord_y, gridcounts
  logical, allocatable, dimension(:) :: inf
  integer, allocatable, dimension(:, :) :: grid
  nlines = 0
  open(lun, file = 'in.txt')
  do
     read(lun,*,iostat=io)
     if (io/=0) exit
     nlines = nlines + 1
  end do
  close(lun)
  open(lun, file = 'in.txt')
  allocate(coord_x(nlines))
  allocate(coord_y(nlines))
  do i = 1,nlines
     read(lun, *) coord_x(i), coord_y(i)
  end do
  minx = minval(coord_x)
  miny = minval(coord_y)
  maxx = maxval(coord_x)
  maxy = maxval(coord_y)

  maxx = maxx - minx
  maxy = maxy - miny
  coord_x = coord_x - minx
  coord_y = coord_y - miny

  allocate(grid(maxx, maxy))
  do x = 1,maxx
     do y = 1,maxy
        clv = 2000000000
        cli = -1
        do i = 1,nlines
           dist = abs(x - coord_x(i)) + abs(y - coord_y(i))
           if (dist == clv) then
              cli = -1
           else if (dist < clv) then
              cli = i
              clv = dist
           end if
        end do
        grid(x, y) = cli
     end do
  end do
  allocate(inf(nlines))
  inf = .false.
  do x = 1, maxx
     if (grid(x, 1) /= -1) then
        inf(grid(x, 1)) = .true.
     end if
     if (grid(x, maxy) /= -1) then
        inf(grid(x, maxy)) = .true.
     end if
  end do
  do y = 1, maxy
     if (grid(1, y) /= -1) then
        inf(grid(1, y)) = .true.
     end if
     if (grid(maxx, y) /= -1) then
        inf(grid(maxx, y)) = .true.
     end if
  end do

  allocate(gridcounts(nlines))
  gridcounts = 0
  do x = 1,maxx
     do y = 1,maxy
        if (grid(x, y) /= -1) then
           gridcounts(grid(x, y)) = gridcounts(grid(x, y)) + 1
        end if
     end do
  end do
  do while (.true.)
     cli = maxloc(gridcounts, 1)
     if (.not. inf(cli)) then
        write(*, *) gridcounts(cli)
        stop
     else
        gridcounts(cli) = 0
     end if
  end do

end program hwrd
