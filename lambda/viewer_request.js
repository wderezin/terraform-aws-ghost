
function handler (event) {
  // Extract the request from the CloudFront event that is sent to Lambda@Edge
  var request = event.request;
  var host = request.headers.host.value;

// %{ if apex_redirect }
  // start apex_redirect to www
  if (host.split('.').length === 2) {
    var response = {
      statusCode: 301,
      statusDescription: 'Redirecting to www domain',
      headers:
        { "location": { "value": `https://www.$${host}$${request.uri}` } }
    }

    return response;
  }
// %{endif}

// %{ if append_slash }
  // Start append_slash
  var olduri = request.uri;
  // Match any uri that ends with some combination of
  // [0-9][a-z][A-Z]_- and append a slash
  var endslashuri = olduri.replace(/(\/[\w\-]+)$/, '$1/');
  if(endslashuri !== olduri) {
    // If we changed the uri, 301 to the version with a slash, appending querystring
    var params = '';
    if(('querystring' in request) && (request.querystring.length>0)) {
      params = '?'+request.querystring;
    }
    var newuri = endslashuri + params;

    var response = {
      statusCode: 301,
      statusDescription: 'Permanently moved',
      headers:
        { "location": { "value": `//$${host}$${newuri}` } }
    }

    return response;
  }
// %{endif}

  // // only need to check for trailing / as the directory checker above will add when needed.
  // if (config.ghost_hostname.length > 0 &&
  //   ((request.uri.startsWith("/ghost/")
  //     || request.uri.endsWith("/edit/")))) {
  //
  //   return {
  //     status: '307',
  //     statusDescription: `Redirecting domain`,
  //     headers: {
  //       location: [{
  //         key: 'Location',
  //         value: `https://$${config.ghost_hostname}$${request.uri}`
  //       }]
  //     },
  //     body: temp_redirect_body
  //   };
  // }

// %{ if index_rewrite }
    // Start index_rewrite
    // Extract the URI from the request
    var olduri = request.uri;

    // Match any '/' that occurs at the end of a URI. Replace it with a default index
    var newuri = olduri.replace(/\/$/, '\/index.html');

    // Log the URI as received by CloudFront and the new URI to be used to fetch from origin
    console.log("Old URI: " + olduri + " New URI: " + newuri);

    // Replace the received URI with the URI that includes the index page
    request.uri = newuri;
// %{endif}

  return request;

};
