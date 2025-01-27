
function slideAndRedirect() {
    // Add the slide-out effect to the body (or a container element)
    document.body.classList.add('slide-out');
    
    // Wait for the animation to complete before redirecting (500ms delay)
    setTimeout(function() {
        // Redirect to the userlogin.cfm page
        window.location.href = 'userlogin.cfm';
    }, 500);  // Timeout duration matches the animation duration
}
