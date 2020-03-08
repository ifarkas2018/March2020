/* Project : Ptica
 * Author : Ingrid Farkas
 * validationJS.js: functions used for validation
 */

NAME_VAL = 'true'; // does the name input field contain only letters (and apostrophe)
FNAME_VAL = 'true'; // does the first name input field contain only letters (and apostrophe)
LNAME_VAL = 'true'; // does the last name input field contain only letters (and apostrophe)
ISBN_VAL = 'true'; // does the ISBN input field contain only digits
PRICE_VAL = 'true'; // does the Price input field contain only digits
PG_VAL = 'true'; // does the Pages input field contain only digits
YRPUBL_VAL = 'true'; // does the Publication Year input field contain only digits

// setVal: depending on the num_type, sets one of the variables to the value
function setVal(num_type, value) {
    if (num_type == 'is_isbn') {
        ISBN_VAL  = value;
    } else if (num_type == 'is_pages') {
        PG_VAL = value;
    } else if (num_type == 'is_price') {
        PRICE_VAL = value;
    } else if (num_type == 'is_yrpubl') {
        YRPUBL_VAL = value;
    }
}

// isNumber: shows a message (in the msg_field) if the user entered a value that is a non numeric value (in the input field named input_field)
// if characters is true, the number can contain a % or _
// if dec_point is true, the number can contain .
// num_type - is the input in the field an isbn, price, pages or a year
// formid: id of the form
function isNumber(formid, input_field, num_type, msg_field, characters, dec_point) {
    var number;
    var regex;
    
    number = document.getElementById(input_field).value;
    if (characters && dec_point) { // %, _ or . can be entered in the input field (beside digits)
        regex = /^[0-9\x25\x5F\x2E]+$/;
    } else if (dec_point) {
        regex = /^[0-9\x2E]+$/;
    } else if (characters) { // % or _ can be entered in the input field (beside digits)
        regex = /^[0-9\x25\x5F]+$/;
    } else {
        regex = /^[0-9]+$/;
    }
    if (number != '') {
        // if the value entered in a isbn is not a nuumber (if characters is true, number can contain a %, _)
        if (!regex.test(number)) {
            if (characters && dec_point) { // %, _, . can be entered in the input field (beside digits)
                document.getElementById(msg_field).innerHTML = "* Can contain only digits (wildcards and decimal point)"; // show the message
            } else if (dec_point) { 
                document.getElementById(msg_field).innerHTML = "* Can contain only digits (and decimal point)"; 
            } else if (characters) {
                document.getElementById(msg_field).innerHTML = "* Can contain only digits (and wildcards)"; 
            } else {
                document.getElementById(msg_field).innerHTML = "* Can contain only digits"; // show the message
            }
            setVal( num_type, 'false' );
        } else {
            setVal( num_type, 'true' );
            document.getElementById(msg_field).innerHTML = ""; // show the message 
        }
    } else {
        setVal( num_type, 'true' );
        document.getElementById(msg_field).innerHTML = ""; // show the message 
    }
}

// setNameVal - depending on whether the user entered full name, first name or last name set the corresponding variable value
// name_type: 'fullname' (the user filled in a full name), 'firstname', 'lastname'
// value: 'true' or 'false'
function setNameVal(name_type, value) {
    switch (name_type) { // depending on whether the user entered full name, first name or last name set the corresponding variable value
        case 'fullname':
            NAME_VAL = value;
            break;
        case 'firstname':
            FNAME_VAL = value;
            break;
        case 'lastname':
            LNAME_VAL = value;
            break;
        default:
    }
}

// valLetters: checks whether in the control input_field there are only letters (or apostrophes, commas, -, space, %, _). If not in the message_span the message is shown.
// required - if the input field was required to be filled in before showing the message, when the user corrects the mistake, below
// is shown again that the input field is required (to be filled in)
// name_type - 'fullname' (the user filled in a full name), 'firstname', 'lastname'
// characters - whether wildcards are allowed in the input field
function valLetters(input_field, message_span, name_type, characters, required) {
    var regex;
    
    if (characters) { // % or _ can be entered in the input field (beside letters, apostrophes, commas, -, space)
        regex = /^[a-zA-Z\x27\x20\x2C\x2D\x25\x5F]+$/;
    } else {
        regex = /^[a-zA-Z\x27\x20\x2C\x2D]+$/;
    }
    if (!input_field.value == '') {
        if (!regex.test(input_field.value)) { // if the user entered some characters which are not letters (in the input_field)
            // NAME_VAL = 'false';
            if (characters)
                message_span.innerHTML = "* Can contain letters, commas, apostrophies, hyphen, space, wildcards";
            else
                message_span.innerHTML = "* Can contain letters, commas, apostrophies, hyphen, space";
            setNameVal(name_type, 'false');
            //NAME_VAL = 'false';
        } else { // the user entered characters which are letters (in the input_field)
            setNameVal(name_type, 'true');
            // @@@@@@@@@@@@ fix this part one name vs 2 names
            //NAME_VAL = 'true';
            if (required == 'true') {
                message_span.innerHTML = "* Required Field";
            } else {
                message_span.innerHTML = "";
            }
        }
    } else {
        if (required == 'true') {
            setNameVal(name_type, 'false');
            // NAME_VAL = 'false';
            message_span.innerHTML = "* Required Field";
        } else {
            setNameVal(name_type, 'true');
            NAME_VAL = 'true';
            message_span.innerHTML = "";
        }
    }
}

// checkForm: if the validation was successful then return TRUE otherwise return FALSE
function checkForm(){
    if ((NAME_VAL === 'true') && (FNAME_VAL === 'true') && (LNAME_VAL === 'true') && (ISBN_VAL === 'true') && (PRICE_VAL === 'true') && (PG_VAL === 'true') && (YRPUBL_VAL === 'true')) { 
        return true;
    } else {
        return false;
    }
}

