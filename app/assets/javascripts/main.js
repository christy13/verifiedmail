window.onload = function(){
  openpgp.init();

  function createCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    } else var expires = "";
    document.cookie = escape(name) + "=" + escape(value) + expires + "; path=/";
  }

  function readCookie(name) {
      var nameEQ = escape(name) + "=";
      var ca = document.cookie.split(';');
      for (var i = 0; i < ca.length; i++) {
          var c = ca[i];
          while (c.charAt(0) == ' ') c = c.substring(1, c.length);
          if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
      }
      return null;
  }

  function eraseCookie(name) {
      createCookie(name, "", -1);
  }

  function showMessages(str){
    console.log(str);
  }

  var publickeystring;
  var privatekeystring;
  var enc_privatekey;
  var signed_hash;
  var stored_hash;

  $("#generate_submit").click(function(e){
    e.preventDefault();
    var keyPair = openpgp.generate_key_pair(1, 1024, $('#email').val(), 
      $("#enc_sk_password").val());
    
    publickeystring = keyPair.publicKeyArmored;
    privatekeystring = keyPair.privateKeyArmored;

    // remove
    createCookie("rsa_keys", 
      JSON.stringify({"public_key": publickeystring, "private_key": privatekeystring}), 
      2);

    $("#success_gen").removeClass("hidden");
    return false;
  });

  $("#hash_submit").click(function(e){
    e.preventDefault();
    // retrieve PK, E(SK)

    var keys = JSON.parse(readCookie("rsa_keys"));

    publickeystring = keys["public_key"];
    privatekeystring = keys["private_key"];
    console.log(privatekeystring)

    var privKey = openpgp.read_privateKey(privatekeystring)[0];
    var password = $("#dec_sk_password").val();
    var proceed = privKey.decryptSecretMPIs(password)

    if (proceed) {
      var message = $("#message_cr").val();
      signed_hash = openpgp.write_signed_message(privKey, message);
      console.log("Signed hash: "+signed_hash)
      
      // store signed_hash with time, email
      var hash_algo = privKey.getPreferredSignatureHashAlgorithm();
      console.log("hash_algo:"+hash_algo)

      stored_hash = openpgp_crypto_hashData(hash_algo, message); //remove

      $("#success_hash").removeClass("hidden");
    } else {
      console.log("Private key encryption failed")
      $("#failure_hash").removeClass("hidden");
    }
    return false;
  });

  $("#verify_submit").click(function(e){
    e.preventDefault();
    var email = $("#from_email");

    //retrieve PK for email, stored message hash
    // var stored_hash = verifiedmail.getHash(email, time);

    // var pubKey = openpgp.read_publicKey(publickeystring)[0];
    // var sig = new openpgp_packet_signature();
    // sig.verify(signed_hash, pubKey);

    // var message = $("#message_ver").val();
    
    // var hash_algo = 8;
    // var message_MPIs = new openpgp_type_mpi().create(message);
    // var public_key_MPIs = pubKey.MPIs;
    // console.log("hash_algo:"+hash_algo)
    // var verified = openpgp_crypto_verifySignature(1, hash_algo, 
    //   message_MPIs, public_key_MPIs, message);

    if (true) {
      $("#success_ver").removeClass("hidden");
    } else {
      $("#failure_ver").removeClass("hidden");
    }
    return false;
  });

  $("#enc_sk_password").val("hello");
  $("#dec_sk_password").val("hello");
  $("#message_cr").val("arf arf");
  $("#message_ver").val("arf arf");
  $("#from_email").val("me@me.edu");

}
