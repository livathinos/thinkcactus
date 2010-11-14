$(document).ready(function(){

	//Make sure the currently active work divs get some class
	//to show that they're active
	$('.tsItem').addClass('activeItem');
	$('.issuesItem').addClass('activeItem');
	
	//Set the item position pointer to zero
	var itemPosition = 0;
	
	$('.next').click(
	function() {
		
		//Check where the active list element is positioned in the list
		var listLength = $(this).siblings('.slider').children('li').length;
		var activeElem = $(this).siblings('.slider').children('li.activeItem');
		itemPosition = $(this).siblings('.slider').children('li').index(activeElem);
		
		//If the list element is anywhere but at the end of the list
		if (itemPosition != listLength--) {
			
			//Make the next item in the list appear
			var itm = $(this).siblings('.slider').children('li.activeItem + li ');
			itm.fadeIn();

			//Make sure the currently active item disappears
			$(this).siblings('.slider').children('.activeItem').removeClass('activeItem').hide();

			//Set the active class to the right li element
			itm.addClass('activeItem');

			//Activate the "previous" link by setting its opacity to full
			$(this).siblings('.previous').css('opacity','1');
			$(this).siblings('.previous').hover().css('cursor','pointer');

			//The end of the list is reached
			if(!($(this).siblings('.slider').children('li.activeItem + li').length)) {

				//Deactivate the next link by setting its opacity to 0.5
				$(this).css('opacity','0.5');
				$(this).hover().css('cursor','default');
				
			}
			
		} 
		
		//Prevent the page from jumping upwards when the next/prev links are clicked
		return false;
	}, 
	function() {
		
	});
	
	$('.previous').click(
	function() {
		
		//Check where the active list element is positioned in the list
		var listLength = $(this).siblings('.slider').children('li').length;
		var activeElem = $(this).siblings('.slider').children('li.activeItem');
		itemPosition = $(this).siblings('.slider').children('li').index(activeElem);
		
		//If the active item is anything other than the first list item
		if (itemPosition > 0) {
			
			//Make the previous item in the list appear
			var pitm = $(this).siblings('.slider').children('li.activeItem').prev();
			pitm.fadeIn();

			//Make sure the currently active item disappears
			$(this).siblings('.slider').children('.activeItem').removeClass('activeItem').hide();

			//Set the active class to the right li element
			pitm.addClass('activeItem');

			//Activate the "previous" link by setting its opacity to full
			$(this).siblings('.next').css('opacity','1');
			$(this).siblings('.next').hover().css('cursor','pointer');

			//Not at the end of the list yet, set the flag accordingly
			endFlag = 0;
			
			//In case the start of the list is reached, set the flag to one
			if(!($(this).siblings('.slider').children('li.activeItem').prev().length)) {
				
				//The start of the list has been reached
				begFlag = 1;

				//Deactivate the next link by setting its opacity to 0.5
				$(this).css('opacity','0.5');
				$(this).hover().css('cursor','default');
				
			}
			
		} 
		
		//Prevent the page from jumping upwards when the next/prev links are clicked
		return false;
	}, 
	function() {
		
	});
	
});
