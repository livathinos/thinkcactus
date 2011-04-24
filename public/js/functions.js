$(document).ready(function(){

	//Make sure the currently active work divs get some class
	//to show that they're active
	$('.excItem').addClass('activeItem');
	$('.issuesItem').addClass('activeItem');
	
	//Set the item position pointer to zero
	var itemPosition = 0;
	
	$('.next').click(
	function() {
		
  	//The end of the list is reached
		if(!($(this).siblings('.slider').children('li.activeItem + li').length)) {

			//Deactivate the next link by setting its opacity to 0.5
			$(this).css('opacity','0.5');
			$(this).hover().css('cursor','default');
			
			endFlag = 1;
			return false;
			
		} else {
		  
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
			
			}
		
		  //Prevent the page from jumping upwards when the next/prev links are clicked
		  return false;
	  }
	}, 
	function() {
		
	});
	
	$('.previous').click(
	function() {
		
		//In case the start of the list is reached, set the flag to one
		if(!($(this).siblings('.slider').children('li.activeItem').prev().length)) {
			
			//The start of the list has been reached
			begFlag = 1;

			//Deactivate the next link by setting its opacity to 0.5
			$(this).css('opacity','0.5');
			$(this).hover().css('cursor','default');
			
			return false;
			
		} else {
		
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
			}
			
  		//Prevent the page from jumping upwards when the next/prev links are clicked
  		return false;
		} 
		
	}, 
	function() {
		
	});
	
});

function relative_time(time_value) {
  var values = time_value.split(" ");
  time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
  var parsed_date = Date.parse(time_value);
  var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
  var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
  delta = delta + (relative_to.getTimezoneOffset() * 60);

  if (delta < 60) {
    return 'less than a minute ago';
  } else if(delta < 120) {
    return 'about a minute ago';
  } else if(delta < (45*60)) {
    return (parseInt(delta / 60)).toString() + ' minutes ago';
  } else if(delta < (90*60)) {
    return 'about an hour ago';
  } else if(delta < (24*60*60)) {
    return 'about ' + (parseInt(delta / 3600)).toString() + ' hours ago';
  } else if(delta < (48*60*60)) {
    return '1 day ago';
  } else {
    return (parseInt(delta / 86400)).toString() + ' days ago';
  }
}

function twitterCallback(obj) {
    var id = obj[0].user.id;
    document.getElementById('my_twitter_status').innerHTML = obj[0].text;
    document.getElementById('my_twitter_status_time').innerHTML = relative_time(obj[0].created_at);
}
