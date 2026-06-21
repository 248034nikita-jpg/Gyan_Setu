

/* MOBILE NAVIGATION MENU*/

const menuToggle = document.querySelector(".menu-toggle");

const navWrapper = document.querySelector(".nav-wrapper");


if(menuToggle && navWrapper){

menuToggle.addEventListener("click", function(){

navWrapper.classList.toggle("show");

});

}


/*CLOSE MENU WHEN NAV LINK IS CLICKED */

const dashboardLinks = document.querySelectorAll(".dashboard-menu a");

dashboardLinks.forEach(function(link){

link.addEventListener("click", function(){

if(navWrapper){

navWrapper.classList.remove("show");

}

});

});


/*CLOSE MENU WHEN HOME PAGE LINKS ARE CLICKED */

const homeLinks = document.querySelectorAll(".nav-links a");

homeLinks.forEach(function(link){

link.addEventListener("click", function(){

if(navWrapper){

navWrapper.classList.remove("show");

}

});

});


/* CLOSE MENU WHEN WINDOW IS RESIZED */

window.addEventListener("resize", function(){

if(window.innerWidth > 768){

if(navWrapper){

navWrapper.classList.remove("show");

}

}

});