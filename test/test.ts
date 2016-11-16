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

import * as app from '../src/app'

app.parserParameterHtml("SERVICE_NAMES")
 
// var document     = parse5.parse('<!DOCTYPE html><html><body>Hi there!</body></html>');
// var documentHtml = parse5.serialize(document.);
// console.info(documentHtml)



const vvv = /ab(\w)/

console.info(vvv.exec("abcabdabgh")[1])
console.info(vvv.exec("abcabdabgh")[1])