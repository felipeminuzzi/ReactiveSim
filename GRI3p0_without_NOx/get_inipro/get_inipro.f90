  module gvar_module
     !
     implicit none
     !
     public
     !
     integer, parameter :: i4b=4
     integer, parameter :: dp=8
     integer, parameter :: clen=100
     !
     ! max number of lines in input file
     integer(i4b),parameter :: mline=100000000
     !
  end module gvar_module
  !
  !
  !
  module io_module
    !
    use gvar_module
    !
    implicit none
    !
    public :: open_insfla_file
    public :: close_insfla_file
    public :: write_inipro
    public :: gotoldat
    !
    contains
    !
    !
    subroutine gotoldat(fu)
      !
      ! go to last "DATA" in fort.3 datafile
      !
      integer(i4b), intent(in) :: fu
      !
      ! local variables
      integer(i4b) :: n
      character(5) :: dc
      !
      do n=1,mline
        read(fu,*,end=201)
      end do
201   continue
      backspace(fu)
      do n=1,mline
        backspace(fu)
        read(fu,'(a)') dc
        if(dc(1:5)=='>DATA') then
          exit
        else
          backspace(fu)
        end if
      end do
      !
      return
      !
    end subroutine gotoldat
    !
    !
    subroutine gotoidat(fu,idat,llast)
      !
      ! go to idat-th "DATA" in fort.3 datafile
      !
      integer(i4b), intent(in) :: fu,idat
      logical, optional, intent(in) :: llast
      !
      ! local variables
      integer(i4b) :: n,icou
      character(5) :: dc
      !
      rewind(fu)
      !
      icou = 0
      do while (icou<idat)
        read(fu,'(a)',end=101) dc
        if(dc(1:5)=='>DATA') then
          icou = icou+1
        end if
      end do
      !
      return
      !
101   continue
      if (present(llast)) then
        if (llast) then
          call gotoldat(fu)
        end if
      else
        print*,'WARNING: Could not find dataset',idat,'in gotoidat'
        stop
      end if
      !
    end subroutine gotoidat
    !
    !
    !
    subroutine readtime(fuins,time)
      !
      integer(i4b), intent(in) :: fuins
      real(dp), intent(out) :: time
      !
      real(dp) :: dum
      !
      read(fuins,84) dum,time
      !
84    format('> TIME (S) ',1pe10.3,4x,1pe25.18)
    end subroutine readtime
    !
    !
    !
    subroutine write_inipro(fuins,fninipro,timein,lappendin)
      !
      integer(i4b), intent(in) :: fuins
      character(*), intent(in) :: fninipro
      real(dp), optional, intent(in) :: timein
      logical, optional, intent(in) :: lappendin
      !
      ! local variables
      integer(i4b) :: fu
      real(dp) :: time
      logical :: lexist
      character(2000) :: cdum
      logical :: lappend
      !
      lappend = .false.
      if (present(lappendin)) lappend = lappendin
      !
      if (present(timein)) then
        time = timein
        read(fuins,'(a)',end=11) cdum
      else
        call readtime(fuins,time)
      end if
      !
      fu = 501
      if (lappend) then
      inquire(file=trim(adjustl(fninipro)),exist=lexist)
      if (lexist) then
        open(fu,file=trim(adjustl(fninipro)),status='old',position='append')
      else
        open(fu,file=trim(adjustl(fninipro)))
      end if
      else
        open(fu,file=trim(adjustl(fninipro)),status='replace')
      end if
      !
      write(fu,'(a)') '>DATA'
      write(fu,84) time,time
10    continue
      read(fuins,'(a)',end=11) cdum
      write(fu,'(a)') trim(cdum)
      goto 10
      !
11    continue
      close(fu)
      return
      !
84    format('> TIME (S) ',1pe10.3,4x,1pe25.18)
      !
    end subroutine write_inipro
    !
    !
    !
    subroutine open_insfla_file(fnins,fuins)
      !
      character(*), intent(in) :: fnins
      integer(i4b), intent(in) :: fuins
      !
      open(unit=fuins,file=trim(fnins),status='old',action='read')
      !
    end subroutine open_insfla_file
    !
    !
    !
    subroutine close_insfla_file(fuins)
      !
      integer(i4b), intent(in) :: fuins
      !
      close(unit=fuins)
      !
    end subroutine close_insfla_file
    !
    !
    !
  end module io_module
  !
  !
  !
  program get_inipro
    !
    use gvar_module
    use io_module
    !
    implicit none
    !
    character(100) :: fnins
    integer(i4b) :: fuins
    !
    fuins = 3
    fnins = 'fort.3'
    call open_insfla_file(fnins,fuins)
    !
    call gotoldat(fuins)
!    call write_inipro(fuins,'inipro')
    call write_inipro(fuins,'inipro',0.0d0)
    !
    call close_insfla_file(fuins)
    !
  end program get_inipro
  !
  !
  !
