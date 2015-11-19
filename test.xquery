xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";
let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
let $authusers:=
       <authusers>
        {
            
            for 
              $p in $CCDB//Person,
                $c in $CCDB//Card,
                $a in $c//AuthorizedUser
      where $p/PId=$a
      return 
          <authuser>
              {$p/PId} {$c/CId}
  
  
              
          </authuser>
        }
    {
    for 
              $p in $CCDB//Person,
                $c in $CCDB//Card,
                $o in $CCDB//Organization,
                $s in $o//Signer
      where $p/PId=$s and
            $o/OId=$c/Owner
      return 
          <authuser>
              {$p/PId} {$c/CId}
  
  
              
          </authuser>
        }
  </authusers>
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
            for $p in $CCDB//Person
                
            let $a:= $authusers//authuser[PId=$p/PId]  
            where count($p//OwnedCard)>=4
                  and count($a)>=3
            return
                <result>
              {$p/PId} {$p/PersonName}
              
  
              
              
          </result>
            
         }
    </query2>
 <query3>
         {
             let $pp:=
             <PersonWhoHasACardLimitsAbove25000>{
             for $p in $CCDB//Person
               let $cc:=
                   for $c1 in $p/OwnedCard
                   let $c2:= $CCDB//Card[CId=$c1]
                   where $c2/Limit>=25000
                   return $c1
               
                 where 
                  not (exists($cc))
                return 
                    $p
             }
             </PersonWhoHasACardLimitsAbove25000>
         
          let $oo:=
           <OrgsWhoHaveASignerInAboveSet>{
            for $o in $CCDB//Organization,
                $s in $o//Signer,
               $x in $pp//Person
              where $x/PId=$s
            return $o
           }
           </OrgsWhoHaveASignerInAboveSet>
           
           for 
               $o in $CCDB//Organization
            let $o2:=
               for  $o1 in $oo//Organization
               where
                $o1/OId=$o/OId
               return $o
              
           where not(exists($o2))
           return 
               for $c in $o/OwnedCard
               let $c2:=$CCDB//Card[CId=$c]
               return <result>
                   {$c2/CId}
                   </result>

               
            
         }
    </query3>
   <query4>
       {
       let $direct:=$authusers
       declare function ($indirect){
        $tmp:=
         for $d in $direct//authuser,
            $i in $indirect//
        where 
           $d/CId=$c/CId and
           $c/Owner=$
           
       }
       }
       </query4>>
  </Query>

  
