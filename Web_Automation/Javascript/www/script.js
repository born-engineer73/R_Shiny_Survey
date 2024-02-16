// Function to send web data to parent window
function sendWebDataToParent() {
  var url = window.location.href;
  var title = document.title;
  window.opener.captureWebData(url, title);
}

// Call sendWebDataToParent() when a link is clicked
$(document).on('click', 'a', function() {
  sendWebDataToParent();
});

// Call sendWebDataToParent() when the page is loaded or navigated
$(window).on('load hashchange', function() {
  sendWebDataToParent();
});
