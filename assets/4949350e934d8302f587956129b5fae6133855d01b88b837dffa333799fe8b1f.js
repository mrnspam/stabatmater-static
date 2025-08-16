// JavaScript Document
jQuery(function($){
	$(window).load(function() {

			/*main function*/
			function glossaryIsotope() {
				var $container = $('.glossary-content');
				$container.imagesLoaded(function(){
					$container.isotope({
						itemSelector: '.glossary-item',
						layoutMode: 'straightDown',
					});
				});
			} glossaryIsotope();

			/*filter*/
			$('.filter a').click(function(){
			  var selector = $(this).attr('data-filter');
				$('.glossary-content').isotope({ filter: selector });
				$(this).parents('ul').find('a').removeClass('active');
				$(this).addClass('active');
			  return false;
			});

			/*resize*/
			var isIE8 = $.browser.msie && +$.browser.version === 8;
			if (isIE8) {
				document.body.onresize = function () {
					glossaryIsotope();
				};
			} else {
				$(window).resize(function () {
					glossaryIsotope();
				});
			}

			// Orientation change
			window.addEventListener("orientationchange", function() {
				glossaryIsotope();
			});

	});
});