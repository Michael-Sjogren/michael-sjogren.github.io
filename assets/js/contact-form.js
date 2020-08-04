(function($) {
    let errors = [];
    $('#contact-form').submit(function(e){
        e.preventDefault();
        submitForm();
    });

    let validateEmail = function(email){
        if(!isString(email)){
            return false;
        }
        let re = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,6})+$/
        let r = new RegExp(re);
        return r.test(email)
    }

    let validateMessage = function(message){
        if(!isString(message)){
            return false
        }
        
        return true
    }

    let validateName = function(name){
        if(!isString(name)){
            return false
        }

        return true
    }
    
    let isString = function(val){
        return (typeof val === 'string' || val instanceof String)
    }

    let clearInputs = function(){
        $('#contact-form #email').val("")
        $('#contact-form #name').val("")
        $('#contact-form #message').val("")
    }

    let submitForm = function(){
        let email = $('#contact-form #email').val()
        let name = $('#contact-form #name').val()
        let message = $('#contact-form #message').val()
        errors = []
        isvalid = true
        if( !validateEmail(email) ) {
            errors.push("Invalid email address.")
            isvalid = false
        }

        if(!validateName(name)){
            errors.push("Please input your name.")
            isvalid = false
        }

        if(!validateMessage(message)){
            errors.push("Please enter a message.")
            isvalid = false
        }
        if (!isvalid) {
            // display errors
            return
        }
        $('#contact-form').fadeOut()
        clearInputs()
        let accessKey = "1405e32f-f6ca-4d39-9b4a-da6e2b6084ba"
        const form = {
            accessKey: accessKey,
            email: email,
            name: name,
            message: message
        }
        const opts = {
            method: 'POST',
            body: JSON.stringify(form),
            headers: { 'Content-Type':'application/json'}
        }
        let url = `https://api.staticforms.xyz/submit`
        fetch(url,opts).then(res=>{
            $('#contact-form').fadeIn()
            $('#contact-form').prepend("<p>Thank you for contacting me. I will get back to you as soon as possible!</p>")
        }).then(res=> console.log(res));
    }


})
(jQuery);