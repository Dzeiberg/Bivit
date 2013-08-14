$(function() {

// jQuery Functions will go here

	$(document).ready(function(){

		$('#popup.single').hide();
		$('#popup.add').hide();		
	
		$('article.article button').bind('click', function(event) {
			event.preventDefault();
			$('#popup.single').bPopup();
		});
		
		$('button#add-article').bind('click', function(event) {
			event.preventDefault();
			$('#popup.add').bPopup();
		});
		
		
		$('button.close').click(function() {
			$('#popup.single').bPopup().close();
			$('#popup.add').bPopup().close();
		});
		
		$('section#industries .slide').carouFredSel({
			width 	: 	"350px",
			auto	:	false,	
			items	:	4,
			scroll	:	2,
			prev	:	"#industries_prev",
			next	:	"#industries_next"
		});
	
		// Resize the Body on .ready and .resize events
		$(document).ready(resized);
		$(window).resize(resized);
		
		function resized() {
			$('body').css({ 'width' : $(window).width() });
			
			// if width is greater than height, set width as max
			
			if ( $(window).width() > $(window).height() ) {
				$('.img-home').css({ 'width' : $(window).width() });
			}
			// if height is greater than width, set height as max
			if ( $(window).height() > $(window).width() ) {
				$('.img-home').css({ 'height' : $(window).height() });
			}	
			
			
		}
		
		
	
	});	
	



// Stop jQuery Functions

}) 

