
## Package management

[fpm]:   https://github.com/jordansissel/fpm
[intro]: http://wiki.debian.org/IntroDebianPackaging
[patch]: http://manpages.ubuntu.com/manpages/precise/en/man1/patch.1.html
[laun1]: https://help.launchpad.net/Packaging/SourceBuilds/GettingStarted
[recip]: https://help.launchpad.net/Packaging/SourceBuilds/Recipes
[repo]:  http://blog.jonliv.es/2011/04/26/creating-your-own-signed-apt-repository-and-debian-packages/

Before anything, create a build host, if one does not exist yet. Above avarage
disk space may be required. Install minimal set of required build tools.

    # apt-get install build-essential debhelper devscripts dh-autoreconf dpkg-sig reprepro

Should you feel a bit lost with package management, please, feel free to
familiarize yourself with this nice [introduction to Debian Packaging][intro].


### Backport packages for Precise

1. Download original software and Debian modifications. Extract and/or patch.
   See [patch(1)][patch] manual for details.

        $ tar xzvf software_version.orig.tar.gz
        $ cd Software
        $ tar xzvf ../software_version.debian.tar.gz

2. Install dependencies mentioned in *debian/control*.

3. Build package.

        $ dpkg-buildpackage -rfakeroot -b

   See chapter *Signing and maintaining a repository* next.


### Bazaar, Launchpad and recipes

**Prerequisites:**

 + Bazaar repository for the program code.

 + Another repository for the packaging information.

0. Install **bzr**(1).

        # apt-get install bzr bzr-builder pbuilder ubuntu-dev-tools

1. Create *recipe*. See [Launchpad Help][recip] for details. Following
   example is for building Gearman.

        # bzr-builder format 0.3 deb-version {debupstream}-0~{revno}-3
        lp:gearmand/1.0
        nest-part packaging lp:~gearman-developers/ubuntu/quantal/gearmand/fix-missing-manpages debian

2. Create source package. Two last arguments are the filename of the recipe
   and a working directory, which will be created.

        $ bzr dailydeb --allow-fallback-to-native <recipe> <workdir>

3. Create build environment with *pbuilder*(8).

        # pbuilder create --debootstrapopts --variant=buildd

4. Build the binary package.

        # pbuilder build <workdir>/*.dsc


### Packaging CPAN modules for Precise

Packaging CPAN modules is fairly easy with [fpm][fpm]. See Github page for
installation instructions. Following is an example of creating a package:

    # fpm -s cpan -t deb --verbose --no-auto-depends --maintainer "tuomas@meetin.gs" -d <dependency> -d <...> --description "Short description" CPAN::Module


### Signing packages and maintaining a repository

Following assumes you already have created package signing keys,
set up key agent and made the repository. For more details,
see [these instructions][repo].

1. Sign the build package.

        $ dpkg-sig --sign builder software_version_arch.deb

2. Add the package to repository.

        $ cd <repository>
        $ reprepro -Vb . includedeb precise <path>/software_version_arch.deb

3. Sync the repository to a web server. Set *repo* to your *.ssh/config*
   to point to a proper host.

        $ rsync -rtvP -e ssh -B 8192 * repo:/var/www/ubuntu/
