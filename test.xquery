xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";
let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
return
    <Query>
     <query1>
        {
            for $o in $CCDB//Organization,
            	$p1 in $CCDB//Person,
            	$p2 in $CCDB//Person,
            	$c in $CCDB//Card,
            	$s in $o//Signer,
            	$a in $c//AuthorizedUser
			where ($c/Limit - $c/Balance<1000)
			and $c/Owner=$o/OId
			and $a=$p1/PId
			and $s=$p2/PId

			
			return 
			    <result>
			        <user>{$p1/PId} {$p1/PersonName}</user>
			        <signer>{$p2/PId} {$p2/PersonName}</signer>
	
			        
			        
			    </result>
        }
  </query1>
  <query2>
        {
            
            for 
            	$p in $CCDB//Person,
              	$c in $CCDB//Card,
              	$a in $c//AuthorizedUser
			where $p/PId=$a
			return 
			    <result>
			        {$p/PId} {$c/CId}
	
  
			        
			    </result>
        }
		union {
		for 
            	$p in $CCDB//Person,
              	$c in $CCDB//Card,
              	$a in $c//AuthorizedUser
			where $p/PId=$a
			return 
			    <result>
			        {$p/PId} {$c/CId}
	
  
			        
			    </result>
        }
  </query2>
  
  </Query>

  
