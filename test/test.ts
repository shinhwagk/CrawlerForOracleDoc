import * as request from 'request'
interface Parameter {
  ParameterType?: string;
  DefaultValue?: string;
  Modifiable?: string;
  Modifiable_in_a_PDB?: string;
  Range_of_values?: string;
  Oracle_RAC?: string
  Basic?: string
  Syntax?: string
}

// // const abc: ABC = { a: 1 }


// import * as htmlparser from "htmlparser2"

// request('http://docs.oracle.com/database/122/REFRN/XML_DB_EVENTS.htm', function (error, response, body) {
//   if (!error && response.statusCode === 200) {
//     var parser = new htmlparser.Parser({
//       onopentagname: (name: string)=>{
        
//       }
//       ontext: (text: string) => {
//         console.log("-->", text);
//       },
//       onclosetag: (tagname: string) => {
//         if (tagname === "script") {
//           console.log("That's it?!");
//         }
//       }
//     });

//     parser.write(body);
//     parser.parseChunk
//     parser.end();
//   }
// })

import  parse5 = require('parse5');

var fragment     = parse5.parseFragment('<td>Yo!</td>');

console.info(fragment.childNodes[0].childNodes[0].value)




