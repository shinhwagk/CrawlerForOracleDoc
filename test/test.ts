import * as request from 'request'
import * as fs from 'fs'
const reg = /<li><a href\="[A-Z][\w-]+\.htm#[\w-]+"><span class="secnum">(\d+\.\d+)<\/span>([\w\s\$]+)<\/a><\/li>/g

const Parameter_DynamicPerformance_DataDictionary: [string, string][] = []

function getREFRN(): Promise<[string, string][]> {
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
getREFRN().then(pdd => {
  const par = pdd.filter(([s1, s2]) => s1.startsWith("1"))
  console.info(par)

})