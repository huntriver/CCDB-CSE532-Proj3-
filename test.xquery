xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";
let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
return
     <query2>
        {
            $CCDB
        }
  </query2>
