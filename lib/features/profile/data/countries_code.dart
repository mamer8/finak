/// Splits a phone number into country code and the phone number.
/// 
/// Takes a phone number string with country code (e.g., "+201027639683")
/// and returns a map with two keys: 'countryCode' and 'phoneNumber'.
/// 
/// Example: "+201027639683" → {'countryCode': '+20', 'phoneNumber': '1027639683'}
Map<String, String> splitPhoneNumber(String fullPhoneNumber) {
  // Check if the input is valid
  if (fullPhoneNumber == null || fullPhoneNumber.isEmpty || !fullPhoneNumber.startsWith('+')) {
    throw ArgumentError('Phone number must start with a "+" and contain a country code');
  }

  // Find the position where the country code ends
  // Most country codes are 1-3 digits after the "+" symbol
  // We'll detect this by looking for patterns
  
  // Start after the "+" symbol
  int countryCodeEndIndex = 1;
  
  // Common country codes with 1 digit: +1 (USA, Canada)
  // Common country codes with 2 digits: +20 (Egypt), +44 (UK), +86 (China), etc.
  // Common country codes with 3 digits: +380 (Ukraine), +971 (UAE), etc.
  
  // We'll use a simplistic but effective approach: 
  // For most countries, assume the country code is the first 2 or 3 digits after "+"
  
  // For country codes like +20 (Egypt), we want to capture just +20
  if (fullPhoneNumber.length > 3) {
    // We'll handle common country codes specifically
    if (fullPhoneNumber.startsWith('+1')) {  // USA, Canada
      countryCodeEndIndex = 2;
    } else if (fullPhoneNumber.startsWith('+20') ||  // Egypt
               fullPhoneNumber.startsWith('+30') ||  // Greece
               fullPhoneNumber.startsWith('+31') ||  // Netherlands
               fullPhoneNumber.startsWith('+32') ||  // Belgium
               fullPhoneNumber.startsWith('+33') ||  // France
               fullPhoneNumber.startsWith('+34') ||  // Spain
               fullPhoneNumber.startsWith('+36') ||  // Hungary
               fullPhoneNumber.startsWith('+39') ||  // Italy
               fullPhoneNumber.startsWith('+40') ||  // Romania
               fullPhoneNumber.startsWith('+41') ||  // Switzerland
               fullPhoneNumber.startsWith('+43') ||  // Austria
               fullPhoneNumber.startsWith('+44') ||  // UK
               fullPhoneNumber.startsWith('+45') ||  // Denmark
               fullPhoneNumber.startsWith('+46') ||  // Sweden
               fullPhoneNumber.startsWith('+47') ||  // Norway
               fullPhoneNumber.startsWith('+48') ||  // Poland
               fullPhoneNumber.startsWith('+49') ||  // Germany
               fullPhoneNumber.startsWith('+51') ||  // Peru
               fullPhoneNumber.startsWith('+52') ||  // Mexico
               fullPhoneNumber.startsWith('+53') ||  // Cuba
               fullPhoneNumber.startsWith('+54') ||  // Argentina
               fullPhoneNumber.startsWith('+55') ||  // Brazil
               fullPhoneNumber.startsWith('+56') ||  // Chile
               fullPhoneNumber.startsWith('+57') ||  // Colombia
               fullPhoneNumber.startsWith('+58') ||  // Venezuela
               fullPhoneNumber.startsWith('+60') ||  // Malaysia
               fullPhoneNumber.startsWith('+61') ||  // Australia
               fullPhoneNumber.startsWith('+62') ||  // Indonesia
               fullPhoneNumber.startsWith('+63') ||  // Philippines
               fullPhoneNumber.startsWith('+64') ||  // New Zealand
               fullPhoneNumber.startsWith('+65') ||  // Singapore
               fullPhoneNumber.startsWith('+66') ||  // Thailand
               fullPhoneNumber.startsWith('+81') ||  // Japan
               fullPhoneNumber.startsWith('+82') ||  // South Korea
               fullPhoneNumber.startsWith('+84') ||  // Vietnam
               fullPhoneNumber.startsWith('+86') ||  // China
               fullPhoneNumber.startsWith('+90') ||  // Turkey
               fullPhoneNumber.startsWith('+91') ||  // India
               fullPhoneNumber.startsWith('+92') ||  // Pakistan
               fullPhoneNumber.startsWith('+93') ||  // Afghanistan
               fullPhoneNumber.startsWith('+94') ||  // Sri Lanka
               fullPhoneNumber.startsWith('+95') ||  // Myanmar
               fullPhoneNumber.startsWith('+98')) {  // Iran
      countryCodeEndIndex = 3;
    } else if (fullPhoneNumber.startsWith('+212') ||  // Morocco
               fullPhoneNumber.startsWith('+213') ||  // Algeria
               fullPhoneNumber.startsWith('+216') ||  // Tunisia
               fullPhoneNumber.startsWith('+218') ||  // Libya
               fullPhoneNumber.startsWith('+220') ||  // Gambia
               fullPhoneNumber.startsWith('+221') ||  // Senegal
               fullPhoneNumber.startsWith('+222') ||  // Mauritania
               fullPhoneNumber.startsWith('+223') ||  // Mali
               fullPhoneNumber.startsWith('+224') ||  // Guinea
               fullPhoneNumber.startsWith('+225') ||  // Côte d'Ivoire
               fullPhoneNumber.startsWith('+226') ||  // Burkina Faso
               fullPhoneNumber.startsWith('+227') ||  // Niger
               fullPhoneNumber.startsWith('+228') ||  // Togo
               fullPhoneNumber.startsWith('+229') ||  // Benin
               fullPhoneNumber.startsWith('+230') ||  // Mauritius
               fullPhoneNumber.startsWith('+231') ||  // Liberia
               fullPhoneNumber.startsWith('+232') ||  // Sierra Leone
               fullPhoneNumber.startsWith('+233') ||  // Ghana
               fullPhoneNumber.startsWith('+234') ||  // Nigeria
               fullPhoneNumber.startsWith('+235') ||  // Chad
               fullPhoneNumber.startsWith('+236') ||  // Central African Republic
               fullPhoneNumber.startsWith('+237') ||  // Cameroon
               fullPhoneNumber.startsWith('+238') ||  // Cape Verde
               fullPhoneNumber.startsWith('+239') ||  // São Tomé and Príncipe
               fullPhoneNumber.startsWith('+240') ||  // Equatorial Guinea
               fullPhoneNumber.startsWith('+241') ||  // Gabon
               fullPhoneNumber.startsWith('+242') ||  // Republic of the Congo
               fullPhoneNumber.startsWith('+243') ||  // Democratic Republic of the Congo
               fullPhoneNumber.startsWith('+244') ||  // Angola
               fullPhoneNumber.startsWith('+245') ||  // Guinea-Bissau
               fullPhoneNumber.startsWith('+246') ||  // British Indian Ocean Territory
               fullPhoneNumber.startsWith('+247') ||  // Ascension Island
               fullPhoneNumber.startsWith('+248') ||  // Seychelles
               fullPhoneNumber.startsWith('+249') ||  // Sudan
               fullPhoneNumber.startsWith('+250') ||  // Rwanda
               fullPhoneNumber.startsWith('+251') ||  // Ethiopia
               fullPhoneNumber.startsWith('+252') ||  // Somalia
               fullPhoneNumber.startsWith('+253') ||  // Djibouti
               fullPhoneNumber.startsWith('+254') ||  // Kenya
               fullPhoneNumber.startsWith('+255') ||  // Tanzania
               fullPhoneNumber.startsWith('+256') ||  // Uganda
               fullPhoneNumber.startsWith('+257') ||  // Burundi
               fullPhoneNumber.startsWith('+258') ||  // Mozambique
               fullPhoneNumber.startsWith('+260') ||  // Zambia
               fullPhoneNumber.startsWith('+261') ||  // Madagascar
               fullPhoneNumber.startsWith('+262') ||  // Réunion
               fullPhoneNumber.startsWith('+263') ||  // Zimbabwe
               fullPhoneNumber.startsWith('+264') ||  // Namibia
               fullPhoneNumber.startsWith('+265') ||  // Malawi
               fullPhoneNumber.startsWith('+266') ||  // Lesotho
               fullPhoneNumber.startsWith('+267') ||  // Botswana
               fullPhoneNumber.startsWith('+268') ||  // Eswatini
               fullPhoneNumber.startsWith('+269') ||  // Comoros
               fullPhoneNumber.startsWith('+290') ||  // Saint Helena
               fullPhoneNumber.startsWith('+291') ||  // Eritrea
               fullPhoneNumber.startsWith('+297') ||  // Aruba
               fullPhoneNumber.startsWith('+298') ||  // Faroe Islands
               fullPhoneNumber.startsWith('+299') ||  // Greenland
               fullPhoneNumber.startsWith('+350') ||  // Gibraltar
               fullPhoneNumber.startsWith('+351') ||  // Portugal
               fullPhoneNumber.startsWith('+352') ||  // Luxembourg
               fullPhoneNumber.startsWith('+353') ||  // Ireland
               fullPhoneNumber.startsWith('+354') ||  // Iceland
               fullPhoneNumber.startsWith('+355') ||  // Albania
               fullPhoneNumber.startsWith('+356') ||  // Malta
               fullPhoneNumber.startsWith('+357') ||  // Cyprus
               fullPhoneNumber.startsWith('+358') ||  // Finland
               fullPhoneNumber.startsWith('+359') ||  // Bulgaria
               fullPhoneNumber.startsWith('+370') ||  // Lithuania
               fullPhoneNumber.startsWith('+371') ||  // Latvia
               fullPhoneNumber.startsWith('+372') ||  // Estonia
               fullPhoneNumber.startsWith('+373') ||  // Moldova
               fullPhoneNumber.startsWith('+374') ||  // Armenia
               fullPhoneNumber.startsWith('+375') ||  // Belarus
               fullPhoneNumber.startsWith('+376') ||  // Andorra
               fullPhoneNumber.startsWith('+377') ||  // Monaco
               fullPhoneNumber.startsWith('+378') ||  // San Marino
               fullPhoneNumber.startsWith('+379') ||  // Vatican City
               fullPhoneNumber.startsWith('+380') ||  // Ukraine
               fullPhoneNumber.startsWith('+381') ||  // Serbia
               fullPhoneNumber.startsWith('+382') ||  // Montenegro
               fullPhoneNumber.startsWith('+383') ||  // Kosovo
               fullPhoneNumber.startsWith('+385') ||  // Croatia
               fullPhoneNumber.startsWith('+386') ||  // Slovenia
               fullPhoneNumber.startsWith('+387') ||  // Bosnia and Herzegovina
               fullPhoneNumber.startsWith('+389') ||  // North Macedonia
               fullPhoneNumber.startsWith('+420') ||  // Czech Republic
               fullPhoneNumber.startsWith('+421') ||  // Slovakia
               fullPhoneNumber.startsWith('+423') ||  // Liechtenstein
               fullPhoneNumber.startsWith('+501') ||  // Belize
               fullPhoneNumber.startsWith('+502') ||  // Guatemala
               fullPhoneNumber.startsWith('+503') ||  // El Salvador
               fullPhoneNumber.startsWith('+504') ||  // Honduras
               fullPhoneNumber.startsWith('+505') ||  // Nicaragua
               fullPhoneNumber.startsWith('+506') ||  // Costa Rica
               fullPhoneNumber.startsWith('+507') ||  // Panama
               fullPhoneNumber.startsWith('+509') ||  // Haiti
               fullPhoneNumber.startsWith('+590') ||  // Saint Barthélemy
               fullPhoneNumber.startsWith('+591') ||  // Bolivia
               fullPhoneNumber.startsWith('+592') ||  // Guyana
               fullPhoneNumber.startsWith('+593') ||  // Ecuador
               fullPhoneNumber.startsWith('+595') ||  // Paraguay
               fullPhoneNumber.startsWith('+598') ||  // Uruguay
               fullPhoneNumber.startsWith('+670') ||  // East Timor
               fullPhoneNumber.startsWith('+672') ||  // Norfolk Island
               fullPhoneNumber.startsWith('+673') ||  // Brunei
               fullPhoneNumber.startsWith('+674') ||  // Nauru
               fullPhoneNumber.startsWith('+675') ||  // Papua New Guinea
               fullPhoneNumber.startsWith('+676') ||  // Tonga
               fullPhoneNumber.startsWith('+677') ||  // Solomon Islands
               fullPhoneNumber.startsWith('+678') ||  // Vanuatu
               fullPhoneNumber.startsWith('+679') ||  // Fiji
               fullPhoneNumber.startsWith('+680') ||  // Palau
               fullPhoneNumber.startsWith('+682') ||  // Cook Islands
               fullPhoneNumber.startsWith('+683') ||  // Niue
               fullPhoneNumber.startsWith('+685') ||  // Samoa
               fullPhoneNumber.startsWith('+686') ||  // Kiribati
               fullPhoneNumber.startsWith('+687') ||  // New Caledonia
               fullPhoneNumber.startsWith('+688') ||  // Tuvalu
               fullPhoneNumber.startsWith('+689') ||  // French Polynesia
               fullPhoneNumber.startsWith('+690') ||  // Tokelau
               fullPhoneNumber.startsWith('+691') ||  // Micronesia
               fullPhoneNumber.startsWith('+692') ||  // Marshall Islands
               fullPhoneNumber.startsWith('+850') ||  // North Korea
               fullPhoneNumber.startsWith('+852') ||  // Hong Kong
               fullPhoneNumber.startsWith('+853') ||  // Macau
               fullPhoneNumber.startsWith('+855') ||  // Cambodia
               fullPhoneNumber.startsWith('+856') ||  // Laos
               fullPhoneNumber.startsWith('+870') ||  // Inmarsat
               fullPhoneNumber.startsWith('+880') ||  // Bangladesh
               fullPhoneNumber.startsWith('+886') ||  // Taiwan
               fullPhoneNumber.startsWith('+960') ||  // Maldives
               fullPhoneNumber.startsWith('+961') ||  // Lebanon
               fullPhoneNumber.startsWith('+962') ||  // Jordan
               fullPhoneNumber.startsWith('+963') ||  // Syria
               fullPhoneNumber.startsWith('+964') ||  // Iraq
               fullPhoneNumber.startsWith('+965') ||  // Kuwait
               fullPhoneNumber.startsWith('+966') ||  // Saudi Arabia
               fullPhoneNumber.startsWith('+967') ||  // Yemen
               fullPhoneNumber.startsWith('+968') ||  // Oman
               fullPhoneNumber.startsWith('+970') ||  // Palestine
               fullPhoneNumber.startsWith('+971') ||  // United Arab Emirates
               fullPhoneNumber.startsWith('+972') ||  // Israel
               fullPhoneNumber.startsWith('+973') ||  // Bahrain
               fullPhoneNumber.startsWith('+974') ||  // Qatar
               fullPhoneNumber.startsWith('+975') ||  // Bhutan
               fullPhoneNumber.startsWith('+976') ||  // Mongolia
               fullPhoneNumber.startsWith('+977') ||  // Nepal
               fullPhoneNumber.startsWith('+992') ||  // Tajikistan
               fullPhoneNumber.startsWith('+993') ||  // Turkmenistan
               fullPhoneNumber.startsWith('+994') ||  // Azerbaijan
               fullPhoneNumber.startsWith('+995') ||  // Georgia
               fullPhoneNumber.startsWith('+996') ||  // Kyrgyzstan
               fullPhoneNumber.startsWith('+998')) {  // Uzbekistan
      countryCodeEndIndex = 4;
    } else {
      // Default to 3 characters for most country codes (including the '+')
      countryCodeEndIndex = 3;
    }
  }

  // Extract the country code
  String countryCode = fullPhoneNumber.substring(0, countryCodeEndIndex);
  
  // Extract the phone number
  String phoneNumber = fullPhoneNumber.substring(countryCodeEndIndex);
  
  return {
    'countryCode': countryCode,
    'phoneNumber': phoneNumber,
  };
}