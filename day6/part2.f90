program part2
  implicit none
  integer, parameter :: lun = 10
  integer :: nlines, io, i, minx, miny, maxx, maxy, dist, x, y, sm, fin
  integer, allocatable, dimension(:) :: coord_x, coord_y
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
        sm = 0
        do i = 1,nlines
           dist = abs(x - coord_x(i)) + abs(y - coord_y(i))
           sm = sm + dist
        end do
        grid(x, y) = sm
     end do
  end do

  fin = sum(merge(1, 0, grid < 10000))
  write(*,*) fin
end program part2
