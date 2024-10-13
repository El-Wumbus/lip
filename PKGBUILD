pkgname=lip-git
_pkgname=lip
pkgver=r3.9d50b88
pkgrel=1
pkgdesc="LIterate Programming (LIP)"
arch=(x86_64)
url="https://git.bleeding.pink/decator/lip"
license=(WTFPL)
depends=()
makedepends=(odin)
provides=()
source=("git+https://git.bleeding.pink/decator/lip.git")
sha256sums=('SKIP')

pkgver() {
    cd "${_pkgname}"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    cd "${_pkgname}"
    odin build . -o:speed
}

package() {
    cd "${_pkgname}"
    
    install -Dm755 ./lip "${pkgdir}/usr/bin/lip"
    install -Dm644 README.md "${pkgdir}/usr/share/doc/${_pkgname}/README.md"
    install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}


