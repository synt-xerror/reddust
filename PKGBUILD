pkgname=reddust
pkgver=2.0
pkgrel=1
pkgdesc="Minimalist programming language."
arch=('x86_64')
url="https://github.com/synt-xerror/reddust"
license=('GPL-3.0')
depends=()
makedepends=('gcc')
source=("reddust.c")
sha256sums=('SKIP')

build() {
    make
}

package() {
    make DESTDIR="$pkgdir" install
}

