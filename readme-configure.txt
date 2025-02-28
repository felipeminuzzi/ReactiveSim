====================================================================================C O M P I L I N G   H O M R E A / I N S F L A
------------------------------------------------------------------------------------
Author:		Andrey Koksharov
Revision:	15.05.2015
====================================================================================

The current document assumes that the installation package is located
~/programs

Then HOMREA must be in: ~/programs/homrea
Then INSFLA must be in: ~/programs/insfla
And Libraries in:	~/programs/library

"$> " - Means terminal command

For more detailing information about configuring the package, please refer to:
http://www.gnu.org/software/autoconf
$> ./configure --help

------------------------------------------------------------------------------------
1.  C O M P I L I N G
------------------------------------------------------------------------------------

1.1. Default settings (without MiniGraphic)

$> cd ~/programs/homrea
$> ./configure
$> make all

the "configure" scripts searches for libraries and sets up compilers.
The most stable options are used for compilers.

Warning! This script must finish without error in order to proceed with "make all".

Resulting binaries are save in:

~/programs/homrea/bin-xxx/hominp{ext}
~/programs/homrea/bin-xxx/homrun{ext}

and

~/programs/insfla/bin-xxx/insinp{ext}
~/programs/insfla/bin-xxx/insrun{ext}


where "xxx" is the compiler name, e.g. "~/programs/homrea/bin-gfortran". The file
extension {ext} is set to the system standard: i.e.
- Linux/MacOS {ext} = "" 
- Windows {ext} = ".exe"


------------------------------------------------------------------------------------
1.2. Enabling MiniGraphic
The MiniGraphik is enabled with options "--with-mg":

$> ./configure --with-mg
$> make all

Warning. X11 Must be installed, often a developer package (e.g. X11-dev) is required.


------------------------------------------------------------------------------------
1.3. Advanced optimisation

To enable 3d level of optimisation use Option "--with-opt":

$> ./configure --with-opt
$> make all


------------------------------------------------------------------------------------
1.4. Debugging information

The following option enables debugging information and disables optimisation.

$> ./configure --with-debug
$> make all

You can wrap block of optionale code for debugging:

#ifdef DEBUG
   <fortran code>
#endif


------------------------------------------------------------------------------------
1.5. Choice of compiler

Virtually any fortan compiler can be used. The script has been tested with "ifort"
and "gfortran". By default the script checks the existence of the following
compilers: gfortran, ifort and g95. The 1st one found is used as a default compiler.

To specify a particular compiler, user should redefine system variable FC:

$> ./configure FC="ifort"

this will try to set fortan compiler to ifort.

Similar, one can specify the c-compiler (required by MiniGraphik) by change the system
variable CC:

$> ./configure CC="icc"


------------------------------------------------------------------------------------
1.6. Target Architecture 32/64 bit

To force the targeted architecture of the executables to 32 bit:

$> ./configure "FCFLAGS=-m32" "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"

To force the targeted architecture of the executables to 64 bit:

$> ./configure "FCFLAGS=-m64" "CFLAGS=-m64" "CXXFLAGS=-m64" "LDFLAGS=-m64"


------------------------------------------------------------------------------------
1.6. Installing

To install binaries to the systems common folder (e.g. linux /etc/local/bin) use:

$> make install

Under linux/macos, root privileges are required to perform this task.



------------------------------------------------------------------------------------
2.  R E C O N F I G U R A T I O N
------------------------------------------------------------------------------------
The configure is a standard GNU package distribution system. For more info see
http://www.gnu.org/software/autoconf.

The "configure" script is generated on the basis of 2 files: 
 "configure.in"		- configuration
 "Makefile.in"		- make file template
 
To generate "configure" script call:

$> autoconf

in the folder with "configure.in" and "Makefile.in".


------------------------------------------------------------------------------------
3.  A D D I N G    N E W   R O U T I N E S   W I T H   M I N I G R A P H I K
------------------------------------------------------------------------------------
Wrap the block of code with with the conditional preprocessor directives:

#ifdef MINI
   <fortran code>
#endif

Preprocessor directives start with "#" and must be located at the beginning of the
line. In this case the preprocessor checks if the macros MINI has been defined.
The macro MINI is passed to the compiler, if the configuration script is called with
"--with-mg":

$> ./configure --with-mg


------------------------------------------------------------------------------------
3.  F A Q
------------------------------------------------------------------------------------
- How to Install gfortran on MacOS?
	1. Install XCode from AppStore
	2. Install MacPorts from "www.macports.org"
	3. From terminal, to install command-line tools
		$> xcode-select --install
	4. Install gcc-suite (includes gfortran)
		$> sudo port install gcc
		
- How to install X11 on MacOS?
	1. Install MacPorts from "www.macports.org"
	$> sudo port install xorg-libX11

- Compiled apps (under cygwin/mingw) do not start?
	The executable probably cannot find required binaries. To overcome that use
	static build (not recommended in general and is forbidden for MacOS):
	$> ./configure "LDFLAGS=-static"
	
- None Standard location of X11?
	i.e. Using Xming (on windows) or XQuartz (on mac) is not recognised automatically
	by the "configure" script. The user must provide manually the path to X11 libraries
	and headers:
	$> ./configure -with-mg --x-includes={path to xheaders} --x-libraries={path to xlibs}

- Undefined reference to `mg2dpl_’?
	1. You are compiling without MiniGraphik, but using old object, which are using it.
	$> make clean
	$> make all

	2. You have inserted a new MiniGraphik output in the program:
	Wrap the block with preprocessor commands:
	#ifdef MINI
 	.. your fortran code with MiniGraphik ..
	#endif

- relocation truncated to fit: R_X86_64_PC32
- 32-bit RIP relative reference out of range (2587097777 max is +/-4GB)
	You have allocated to much memory in the common block. 
	1. Try to reduce static memory allocation in the common block below 4GB
	2. Force a different memory model to the compiler. It makes the code run slower and
	 it may not work on all platforms
	$> ./configure FCFLAGS="-mcmodel=medium"
			
