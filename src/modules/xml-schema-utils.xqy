xquery version "1.0-ml";

module namespace xsu = "http://marklogic.com/xml-schema-utilities";
(:
import module namespace xsu = "http://marklogic.com/xml-schema-utilities" at "/modules/xml-schema-utils.xqy"; 
:)
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

declare variable $xsu:representation-terms := ('Address', 'Amount', 'Amt', 'Code', 'Count', 'Date', 'Fraction', 'Id', 'Identifier', 'Ind', 'Indicator', 'Level', 'Nbr', 'Measure', 'Name', 'Number', 'Range', 'Time', 'Uri', 'Value', 'Year');

(: taken from http://www.xqueryfunctions.com/xq/functx_camel-case-to-words.html 
xsu:camel-case-to-words('IndividualPersonCode', ',') -> Individual,Person,Code
:)
 declare function xsu:camel-case-to-sequence($arg as xs:string?)  as xs:string* {
   (: put in dashes before each uppercase letter :)
   let $replace := replace($arg,'(\p{Lu})', '-$1')
   let $first-char := substring($replace, 1, 1)
   return
     if ($first-char = '-')
       then tokenize(substring($replace, 2), '-') 
       else tokenize($replace, '-')
 };
 
 (: given an input like fooBarBla this will return "Bla" :)
  declare function xsu:last-camel-case-word($arg as xs:string?)  as xs:string {
   (: put in dashes before each uppercase letter :)
   let $replace := replace($arg,'(\p{Lu})', '-$1')
   let $first-char := substring($replace, 1, 1)
   return
     if ($first-char = '-')
       then tokenize(substring($replace, 2), '-')[last()]
       else tokenize($replace, '-')[last()]
 };


declare function xsu:name-score($name as xs:string) {
  let $has-upper :=
    if (matches($name, '.*[A-Z]'))
      then 'U'
      else ()
  let $has-lower := 

     if (matches($name, '.*[a-z]'))
         then 'l'
      else ()
        return concat($has-upper, '-', $has-lower)
};


declare function xsu:complex-type-to-skos($complex-type as element()) {
   let $name := $complex-type/@name/string()
   let $parse-camel-case-name := xsu:camel-case-to-sequence($name)
   let $uri := '/niem-concepts/complex-types/' || $name || '.xml'
      
    return
      <Concept xmlns="http://www.w3.org/2004/02/skos/core#" about="http://release.niem.gov/niem/niem-core/3.0/complex-type/{$name}">
         <prefLabel>{$name}</prefLabel>
         <definition>{$complex-type/xs:annotation/xs:documentation/text()}</definition>
         <broader>{$complex-type/xs:complexContent/xs:extension/@base/string()}</broader>
         {for $token in $parse-camel-case-name
            return <altLabel>{$token}</altLabel>
         }
      </Concept>
};


declare function xsu:element-to-skos($element as element()) {
   let $name := $element/@name/string()
   let $parse-camel-case-name := xsu:camel-case-to-sequence($name)
   let $last-token := $parse-camel-case-name[last()]
   let $uri := '/niem-concepts/elements/' || $name || '.xml'
      
    return
      <Concept xmlns="http://www.w3.org/2004/02/skos/core#" about="http://release.niem.gov/niem/niem-core/3.0/complex-type/{$name}">
         <prefLabel>{$name}</prefLabel>
         <definition>{$element/xs:annotation/xs:documentation/text()}</definition>
         <broader>{$element/@type/string()}</broader>
         {for $token in $parse-camel-case-name
            return <altLabel>{$token}</altLabel>
         }
         { (: if the last token is in our list of representation terms then we add it to the collection via
             member :)
           if ($last-token = $xsu:representation-terms)
            then
               <member>{$last-token}</member>
            else ()
         }
      </Concept>
};

declare function xsu:concept-to-html($concept as element()) {
let $uri := xdmp:node-uri($concept)
return
<div class="skos-concept">
    <span class="field-label">Name:</span> <b>{$concept/skos:prefLabel/text()}</b><br/>  
    <span class="field-label">Definition:</span> {$concept/skos:definition/text()}<br/>
    <span class="field-label">Broader:</span> {$concept/skos:broader/text()}<br/>
    {for $alt-label in $concept/skos:altLabel
       return
          <div>
             <span class="field-label">Alt Label:</span> {$alt-label/text()}<br/>
          </div>
    }
    <span class="field-label">Member:</span> {$concept/skos:member/text()}<br/>
              <div class="green-url"><a href="/views/view-xml.xqy?uri={$uri}">{$uri}</a></div>
       <div class="button-actions">
         <span class="field-label">Actions:</span>
         <a class="btn btn-info" role="button" href="/views/view-skos-concept.xqy?uri={$uri}">View Details</a>
         <a class="btn btn-info" role="button" href="/views/view-xml.xqy?uri={$uri}">View XML</a>
         <a class="btn btn-info" role="button" href="/scripts/add-to-wantlist-list.xqy?uri={$uri}">Add to Wantlist</a>
      </div>
</div>
};