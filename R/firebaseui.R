#' Firebase UI
#'
#' Firebase UI for web
#'
#' @import htmlwidgets
#'
#' @export
firebaseui <- function(x, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    message = message
  )


  onSuccessRedirectUrl <- "http://www.symbolix.com.au"
  tosUrl <- "http://www.symbolix.com.au"

  headerGstatic <- paste0('<script src="https://www.gstatic.com/firebasejs/4.6.1/firebase.js"></script>')

  headerInitialise <- paste0('<script>
    // Initialize Firebase
  var config = {
    apiKey: "AIzaSyAFA6pgx3YT0Bh3myVEk2NHHxbgmOD_BCk",
    authDomain: "fir-ui-r.firebaseapp.com",
    databaseURL: "https://fir-ui-r.firebaseio.com",
    projectId: "fir-ui-r",
    storageBucket: "",
    messagingSenderId: "170770909575"
  };
  firebase.initializeApp(config);
  </script>')

  headerConfig <- paste0('<script type="text/javascript">
    // FirebaseUI config.
  var uiConfig = {
    signInSuccessUrl: "', onSuccessRedirectUrl, '",
    signInOptions: [
      // Leave the lines as is for the providers you want to offer your users.
      firebase.auth.GoogleAuthProvider.PROVIDER_ID,
      firebase.auth.FacebookAuthProvider.PROVIDER_ID,
      firebase.auth.TwitterAuthProvider.PROVIDER_ID,
      firebase.auth.GithubAuthProvider.PROVIDER_ID,
      firebase.auth.EmailAuthProvider.PROVIDER_ID,
      firebase.auth.PhoneAuthProvider.PROVIDER_ID
      ],
    // Terms of service url.
    tosUrl: "', tosUrl, '"
  };')

  headerWidget <- paste0('
  // Initialize the FirebaseUI Widget using Firebase.
  var ui = new firebaseui.auth.AuthUI(firebase.auth());
  // The start method will wait until the DOM is loaded.
  ui.start("#firebaseui-auth-container", uiConfig);
  </script>'
    )

  # create widget
  firebaseui <- htmlwidgets::createWidget(
    name = 'firebaseui',
    x,
    width = width,
    height = height,
    package = 'firebaseui',
    elementId = elementId
  )

  firebaseui$dependencies <- c(
    firebaseui$dependencies,
     list(
       htmltools::htmlDependency(
         name = "fire",
         version = "99999",
         src = ".",
         head = paste0(headerGstatic, headerInitialise, headerConfig, headerWidget),
         all_files = FALSE
       )
     )
  )

  return(firebaseui)

}

#' Shiny bindings for firebaseui
#'
#' Output and render functions for using firebaseui within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a firebaseui
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name firebaseui-shiny
#'
#' @export
firebaseuiOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'firebaseui', width, height, package = 'firebaseui')
}

#' @rdname firebaseui-shiny
#' @export
renderFirebaseui <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, firebaseuiOutput, env, quoted = TRUE)
}