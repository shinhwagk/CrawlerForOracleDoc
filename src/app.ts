import * as request from 'request'
import * as fs from 'fs'
import parse5 = require('parse5');


const Parameter_DynamicPerformance_DataDictionary: [string, string][] = []

function getREFRN(): Promise<[string, string][]> {
  const reg = /<li><a href\="[A-Z][\w-]+\.htm#[\w-]+"><span class="secnum">(\d+\.\d+)<\/span>([\w\s\$]+)<\/a><\/li>/g

  return new Promise((resolve, rejectd) => {
    request('http://docs.oracle.com/database/122/REFRN/toc.htm', function (error, response, body) {
      if (!error && response.statusCode === 200) {
        let n
        while ((n = reg.exec(body)) !== null) {
          Parameter_DynamicPerformance_DataDictionary.push([n[1], n[2]])
        }
        resolve(Parameter_DynamicPerformance_DataDictionary)
      } else {
        throw new Error(error)
      }
    })
  })
}

function filterDataDictionaryView(item: [string, string]): boolean {
  return item[0].startsWith("2") || item[0].startsWith("3") || item[0].startsWith("4") || item[0].startsWith("5") || item[0].startsWith("6")
}

function filterDynamicPerformanceView(item: [string, string]): boolean {
  return item[0].startsWith("7") || item[0].startsWith("9") || item[0].startsWith("8")
}

function filterParameter(item: [string, string]): boolean {
  return item[0].startsWith("1")
}

getREFRN().then(pdd => {
  const DataDictionaryViews: [string, string][] = pdd.filter(filterDataDictionaryView)
  const Parameters: [string, string][] = pdd.filter(filterParameter)
  const DynamicPerformanceViews: [string, string][] = pdd.filter(filterDynamicPerformanceView)
  // Parameters.forEach(([n, s]) => console.info(Number(n.toString().split('.')[1])))
  console.info("count: " + DataDictionaryViews.length)
  // fs.writeFile('tmp.json',JSON.stringify(DataDictionaryViews))
})

export function parserParameterHtml(name: string) {
  // return new Promise((resolve, rejectd) => {
  const reg = /<p><span class\="bold">([\s\w]*)<\/span><\/p>\s*<\/td>\s*<td class\="[\w\d]+" headers\="[\w\d\s]*">\s*(.*)\s*<\/td>/g

  request(`http://docs.oracle.com/database/122/REFRN/${name}.htm`, function (error, response, body) {
    if (!error && response.statusCode === 200) {
      // console.info(regx.exec(body)[1])
      // console.info(regx.exec(body)[1])
      // console.info(regx.exec(body)[1])
      let column = []
      let n
      while ((n = reg.exec(body)) !== null) {
        column.push([n[1],n[2]])
      }
      console.info(column)
    } else {
      throw new Error(error)
    }
  })
  // })
}

// function extractName()

// var myRe = /ab*/g;
// var str = 'abbcdefabh';
// var myArray;
// while ((myArray = myRe.exec(str)) !=== null) {
//   var msg = 'Found ' + myArray[0] + '. ';
//   msg += 'Next match starts at ' + myRe.lastIndex;
//   console.log(msg);
// }