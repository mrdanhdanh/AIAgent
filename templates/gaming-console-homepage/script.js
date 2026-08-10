/* ============================================================
   NEXA X1 — Gaming Console Homepage
   Vanilla JS, no external dependencies.
   1. Mobile nav toggle
   2. Scroll reveal (IntersectionObserver)
   3. Contact form -> mailto handler
   4. Dynamic year in footer
   ============================================================ */

(function () {
  'use strict';

  /* ---------- 1. Mobile nav toggle ---------- */
  var toggle = document.querySelector('.nav-toggle');
  var mobileNav = document.getElementById('nav-links-mobile');

  if (toggle && mobileNav) {
    toggle.addEventListener('click', function () {
      var open = mobileNav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
      toggle.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
    });

    // Close the mobile menu after tapping a link
    mobileNav.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        mobileNav.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
        toggle.setAttribute('aria-label', 'Open menu');
      });
    });
  }

  /* ---------- 2. Scroll reveal ---------- */
  var revealEls = document.querySelectorAll('.reveal');

  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('in-view');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

    revealEls.forEach(function (el) { io.observe(el); });
  } else {
    // Fallback: reveal everything immediately
    revealEls.forEach(function (el) { el.classList.add('in-view'); });
  }

  /* ---------- 3. Contact form -> mailto ---------- */
  var form = document.querySelector('.contact-form');

  if (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var name = document.getElementById('cf-name');
      var email = document.getElementById('cf-email');
      var message = document.getElementById('cf-message');

      if (!name || !email || !message) return;

      var subject = encodeURIComponent('NEXA X1 enquiry from ' + name.value.trim());
      var body = encodeURIComponent(
        'Name: ' + name.value.trim() + '\n' +
        'Email: ' + email.value.trim() + '\n\n' +
        message.value.trim()
      );
      var mailto = 'mailto:support@nexa-gaming.com?subject=' + subject + '&body=' + body;
      window.location.href = mailto;
    });
  }

  /* ---------- 4. Dynamic year ---------- */
  var year = document.getElementById('year');
  if (year) {
    year.textContent = String(new Date().getFullYear());
  }
})();
