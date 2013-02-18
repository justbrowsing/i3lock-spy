# Maintainer: justbrowsing <developer4linux+aur@gmail.com>
# Contributor: Thorsten Topper <atsutane-tu@freethoughts.de>

pkgname=i3lock-spy
_pkgname=i3lock
pkgver=2.4.1
pkgrel=2
pkgdesc="A screenlocker with intruder detection"
arch=('i686' 'x86_64' 'arm')
url="http://i3wm.org/i3lock/"
license=('MIT')
groups=("justbrowsing")
depends=('xcb-util-image' 'xcb-util-keysyms' 'pam' 'libev' 'cairo' 'fswebcam')
optdepends=('wbar: To add a lockscreen panel')
conflicts=('i3lock')
provides=('i3lock')
options=('docs')
backup=("etc/pam.d/i3lock")
source=("http://i3wm.org/i3lock/${_pkgname}-$pkgver.tar.bz2" "https://raw.github.com/justbrowsing/i3lock-spy/master/i3lock-sentry")
md5sums=('fbc954133a6335be89e394d9ec85fcfd' '0a9817fd0080bf6cb51671a17ea9ca6d')

build() {
  cd "${srcdir}/${_pkgname}-${pkgver}"

  # Add i3lock-sentry hooks
  sed -i 's/Now free this timeout. \*\//&\n    _SED__NEWLINE_/g' i3lock.c
  sed -i 's/_SED__NEWLINE_/system("\/usr\/bin\/i3lock-sentry fail \&"); \/\* i3lock-spy \*\//g' i3lock.c
  sed -i 's/DEBUG("successfully authenticated\\n");/&\n        _SED__NEWLINE_/g' i3lock.c
  sed -i 's/_SED__NEWLINE_/system("\/usr\/bin\/i3lock-sentry parse \&"); \/\* i3lock-spy \*\//g' i3lock.c

  # Add mouse support
  sed -i 's/XCB_EVENT_MASK_KEY_RELEASE |/&\n                _SED__NEWLINE_/g' xcb.c
  sed -i 's/_SED__NEWLINE_/XCB_EVENT_MASK_BUTTON_PRESS | \/\* i3lock-spy \*\//g' xcb.c
  sed -i '/int tries = 10000;/,/kcookie = xcb_grab_keyboard(/{/int tries = 10000;/!{/kcookie = xcb_grab_keyboard(/!d}}' xcb.c
  sed -i 's/int tries = 10000;/&\n      _SED__NEWLINE_/g' xcb.c
  sed -i 's/_SED__NEWLINE_/while (tries-- > 0) { \/\* i3lock-spy \*\//g' xcb.c

  # Add top wbar panel support
  sed -i 's/                      0, 0,/                      0, 64, \/\* i3lock-spy \*\//g' xcb.c
  sed -i 's/scr->height_in_pixels/(&-64)/g' xcb.c
  sed -i 's/values\[0\] = XCB_STACK_MODE_ABOVE/values\[1\] = XCB_STACK_MODE_ABOVE \/\* i3lock-spy \*\//g' xcb.c

  # Fix ticket FS#31544, sed line taken from gentoo
  sed -i -e 's:login:system-auth:' i3lock.pam

  make
  gzip i3lock.1
}

package() {
  cd $srcdir
  mkdir -p $pkgdir/usr/bin
  cp i3lock-sentry $pkgdir/usr/bin/
  chmod +x $pkgdir/usr/bin/i3lock-sentry

  cd "${srcdir}/${_pkgname}-${pkgver}"
  make DESTDIR="${pkgdir}" install
  
  install -Dm644 i3lock.1.gz ${pkgdir}/usr/share/man/man1/i3lock.1.gz
  install -Dm644 LICENSE ${pkgdir}/usr/share/licenses/${_pkgname}/LICENSE
  make clean
}

