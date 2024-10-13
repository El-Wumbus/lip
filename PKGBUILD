pkgname=lip-git
_pkgname=lip
pkgver=r3.9d50b88
pkgrel=1
pkgdesc="LIterate Programming (LIP)"
arch=(x86_64)
url="https://git.bleeding.pink/decator/codestuffs"
license=(WTFPL)
depends=()
makedepends=(odin)
provides=()
source=("git+https://git.bleeding.pink/decator/codestuffs.git")
sha256sums=('SKIP')

pkgver() {
    cd "codestuffs/${_pkgname}"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    cd "codestuffs/${_pkgname}"
    odin build . -o:speed
}

package() {
    cd "codestuffs/${_pkgname}"
    
    install -Dm755 ./lip "${pkgdir}/usr/bin/lip"
    install -Dm644 README.md "${pkgdir}/usr/share/doc/${_pkgname}/README.md"
    install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}


