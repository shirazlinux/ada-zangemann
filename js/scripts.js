

if (monhash = window.location.hash)  {
    scrollToId(monhash)
}

function scrollToId(monhash) {
    var monhash = monhash.substring(1);
    var mapage = document.getElementById(monhash);
    if (mapage) {
        var mapagey = mapage.offsetTop;
        var conteneur = document.getElementById('conte');
        console.log("scroll to ", monhash);
        conteneur.scrollTo({
            top: mapage.offsetTop,
            /* behavior: 'smooth' */
        });
    }
}

// update location hash on scroll
// and activate scroll hints

window.addEventListener('load', () => {

    const allPages = document.querySelectorAll('.ada-page');
    const allHScroll = document.querySelectorAll('.horizontal-scroll');
    if (document.getElementById('conte')) {
      var conteneur = document.getElementById('conte');
      conteneur.focus();
    } else {
      var conteneur = document.getElementsByTagName('article')[0]
    };
    
    conteneur.addEventListener('click', (e) => {
        document.getElementById('menu-collapsed').checked = false;
    });
    conteneur.addEventListener('scroll', (e) => {
        document.getElementById('menu-collapsed').checked = false;

        allPages.forEach(page => {
          const rect = page.getBoundingClientRect();
          if (rect.top >= 0 && rect.top < 150) {
            var pageName = page.getAttribute('id');
            /* console.log("update hash", pageName) */
            const oldHash = window.location.hash;
            if ('#' + pageName != oldHash) {  
                const location = window.location.toString().split('#')[0];
                history.replaceState(null, null, location + '#' + pageName); 
            }
          };
          allHScroll.forEach(hScroll => {
            const rect = hScroll.getBoundingClientRect();
            if (rect.top >= 0 && rect.top < 150) {
              hScroll.classList.add('on-screen');
            } else {
              hScroll.classList.remove('on-screen');
            }
          });

        });
    });
  });


