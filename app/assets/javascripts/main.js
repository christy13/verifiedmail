window.onload = function(){
  openpgp.init();

  // OpenPGPjs will not work without this
  function showMessages(str){
    console.log(str);
  }

  //// Global Variables
  var serverURL = "https://verifiedmail.herokuapp.com/";
  var hash_algo = 8;  // SHA-256, http://tools.ietf.org/html/rfc4880#section-9.4
  var objectSelector = 0;  // Select OpenPGPjs object from list

  //// Helper functions

  // Sends new keys to server
  function uploadKeys(pk, esk) {
    var data = JSON.stringify({public_key: pk, e_secret_key: esk});
    var query = "new_rsakey";
    var resp = $.post(serverURL+query, data);
    return JSON.parse(resp);
  }

  // Retrieves keys from server
  function getKeys() {
    var query = "show_keys";
    var resp = $.get(serverURL+query);
    return JSON.parse(resp);
  }

  // Retrieves public key from server
  function getPublicKey(email) {
    var query = "show_public_key"+"?email="+email;
    var resp = $.get(serverURL+query);
    return JSON.parse(resp);
  }

  // Uploads signed and unsigned hashes
  function uploadHashes(signed_hash, unsigned_hash) {
    var data = JSON.stringify({signed: signed_hash, 
      unsigned: unsigned_hash});
    var query = "new_mhashes";
    var resp = $.post(serverURL+query, data);
    return JSON.parse(resp);
  }

  // Retrieves signed hashes
  function getSignedHash(email, unsigned_hash) {
    var query = "show_signed_hash"+"?email="+email+"&unsigned="+unsigned_hash;
    var resp = $.get(serverURL+query);
    return JSON.parse(resp);
  }

  // Display success message
  function displayResult(success) {
    if (success) {
      $(".success_message").removeClass("hidden");
      $(".failure_message").addClass("hidden");
    } else {
      $(".failure_message").removeClass("hidden");
      $(".success_message").addClass("hidden");
    }
    return false;
  }

  //// Main functions

  // Generates 1024-bit RSA keys for logged in user
  $("#generate_submit").click(function(e){
    e.preventDefault();

    // Generates RSA keys with SK encrypted with password
    var email = "you@example.com";  // email doesn't really matter here
    var keyPair = openpgp.generate_key_pair(1, 1024, email, 
      $("#enc_sk_password").val());
    
    publickeystring = keyPair.publicKeyArmored;
    eprivatekeystring = keyPair.privateKeyArmored;

    // Upload keys to server
    var resp = uploadKeys(publickeystring, eprivatekeystring);

    // Display success/failure
    var success = (resp['success'] == 'true');
    displayResult(success);

    return false;  // Prevent event from bubbling up
  });

  $("#hash_submit").click(function(e){
    e.preventDefault();
    
    // Retrieve keys
    var keys = getKeys();
    publickeystring = keys["public_key"];
    privatekeystring = keys["e_private_key"];

    // Decrypt private key
    var privKey = openpgp.read_privateKey(privatekeystring)[0];
    var password = $("#dec_sk_password").val();
    var proceed = privKey.decryptSecretMPIs(password)

    // If private key decrypts with password
    if (proceed) {
      // Create unsigned hash of message
      var unsigned_hash = openpgp_crypto_hashData(hash_algo, message);
      
      // Create signed hash of message
      var message = $("#message_cr").val();
      var signed_hash = openpgp.write_signed_message(privKey, unsigned_hash);
      console.log("Signed hash: "+signed_hash)

      // Upload signed hash and unsigned hash of message
      var resp = uploadHashes(signed_hash, unsigned_hash);
      var success = (resp['success'] == 'true');
      
      // Display success/failure message
      displayResult(success);
      console.log("Uploading hashes failed")
    } else {
      console.log("Private key encryption failed")
      displayResult(false);
    }
    return false;
  });

  $("#verify_submit").click(function(e){
    e.preventDefault();
    var email = $("#from_email");

    // Retrieve message hash
    var message = $("#message_ver").val();
    var local_message_hash = openpgp_crypto_hashData(hash_algo, message);
    var signed_hash = getSignedHash(email, local_message_hash);

    // Retrieve PK
    var pk = getPublicKey(email);
    var proceed = (pk['success'] == 'true');

    // If public key is retrieved
    if (proceed) {
      // Create key and message objects for PGP library
      var publickeystring = pk["public_key"];
      var pubKey = openpgp.read_publicKey(publickeystring);
      var signed_hash_obj = openpgp.read_message(signed_hash);
      
      // Verify server signed hash
      var verify_server_hash = signed_hash_obj[objectSelector].verifySignature(pubKey[objectSelector]);

      // Verify local == server message hash
      var server_message_hash = signed_hash_obj[objectSelector].text.replace(/\r\n/g,"").replace(/\n/g,"");
      var verify_message_hash = (local_message_hash == server_message_hash);
      var verified = (verify_message_hash && verify_server_hash);

      // Display success/failure message
      displayResult(verified);
    } else {
      // Display success/failure message
      displayResult(false);
    }
    return false;
  });

  // For Demo
  $("#enc_sk_password").val("hello");
  $("#dec_sk_password").val("hello");
  $("#message_cr").val("arf arf");
  $("#message_ver").val("arf arf");
  $("#from_email").val("christy@mit.edu");

}
