# Spreadsheet Instructions
_Last updated 19 January 2022_
## [Video Demonstration](https://vimeo.com/675022150)
## Table of Contents
 - [Spreadsheet Structure](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#spreadsheet-structure)
 - [General Rules](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#general-rules)
 - Spreadsheet columns
   - [Not Mapped](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#not-mapped)
   - [MARCField](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcfield)
   - [MARCFieldLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcfieldlabel)
   - [MARCInd1Label](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcind1label)
   - [MARCInd1Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcind1value)
   - [MARCInd1ValueLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcind1valuelabel)
   - [MARCInd2Label](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcind2label)
   - [MARCInd2Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcind2value)
   - [MARCInd2ValueLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcind2valuelabel)
   - [CharacterPosition](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#characterposition)
   - [CharacterPositionLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#characterpositionlabel)
   - [MARCSubfield](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcsubfield)
   - [MARCSubfieldLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marcsubfieldlabel)
   - [CodeValue](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#codevalue)
   - [CodeValueLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#codevaluelabel)
   - [MARCTagCondition1](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marctagcondition1)
   - [Condition1Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#condition1value)
   - [MARCTagCondition2](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#marctagcondition2)
   - [Condition2Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#condition2value)
   - [RDA Registry URI](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#rda-registry-uri)
   - [RDA Registry Label](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#rda-registry-label)
   - [Recording Method](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#recording-Method)
   - [Justification for Mapping](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#justification-for-mapping)
   - [Transformation Notes](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#transformation-notes)
   - [Problems with Mapping](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#problems-with-mapping)
   - [Notes (Uncategorized)](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#notes-uncategorized)
 
 ## Spreadsheet Structure
 ### Example of an incomplete mapping
 These rows only contain the information for a possible MARC 21 field. These rows will require mapping to an RDA property, and possibly the addition of conditions or notes. Additional rows may need to be added to articulate multiple conditions, or multiple possible RDA properties.
 
 | Not Mapped | MARCField | MARCFieldLabel | MARCInd1Label | MARCInd1Value | MARCInd1ValueLabel | MARCInd2Label | MARCInd2Value | MARCInd2ValueLabel | CharacterPosition | CharacterPositionLabel | MARCSubfield | MARCSubfieldLabel | CodeValue | CodeValueLabel | MARCTagCondition1 | Condition1Values | MARCTagCondition2 | Condition2Values | RDA Registry URI | RDA Registry Label | Recording Method | Justification for Mapping | Transformation Notes | Problems with Mapping | Notes (Uncategorized) | Milestone |
 |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
 | | 210 | ABBREVIATED TITLE (R) | Title added entry | 0 | No added entry | Type | # | Abbreviated key title | | | a | Abbreviated title (NR) | | | | | | | | | | | | | | |
 
 ### Example of a partially-complete mapping
 These rows contain mappings adapted from the [RSC Technical Working Group's RDA-to-MARC 21 mapping](http://www.rdaregistry.info/Maps/mapRDA2M21B.html). These mappings should be reviewed and edited as necessary.
 
 | Not Mapped | MARCField | MARCFieldLabel | MARCInd1Label | MARCInd1Value | MARCInd1ValueLabel | MARCInd2Label | MARCInd2Value | MARCInd2ValueLabel | CharacterPosition | CharacterPositionLabel | MARCSubfield | MARCSubfieldLabel | CodeValue | CodeValueLabel | MARCTagCondition1 | Condition1Values | MARCTagCondition2 | Condition2Values | RDA Registry URI | RDA Registry Label | Recording Method | Justification for Mapping | Transformation Notes | Problems with Mapping | Notes (Uncategorized) | Milestone |
 |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
 | | 264 | PRODUCTION, PUBLICATION, DISTRIBUTION, MANUFACTURE, AND COPYRIGHT NOTICE (R) | Sequence of statements | * | | Function of entity | 4 | Copyright notice date | | | c | Date of production, publication, distribution, manufacture, or copyright notice (R) | | | | | | | http://rdaregistry.info/Elements/m/P30007 | has copyright date | | | | | | |
 
 ### Example of a complete mapping
 These rows have been filled-out, reviewed, and marked as completed in the [project page](https://github.com/uwlib-cams/MARC2RDA/projects/1).
 
 | Not Mapped | MARCField | MARCFieldLabel | MARCInd1Label | MARCInd1Value | MARCInd1ValueLabel | MARCInd2Label | MARCInd2Value | MARCInd2ValueLabel | CharacterPosition | CharacterPositionLabel | MARCSubfield | MARCSubfieldLabel | CodeValue | CodeValueLabel | MARCTagCondition1 | Condition1Values | MARCTagCondition2 | Condition2Values | RDA Registry URI | RDA Registry Label | Recording Method | Justification for Mapping | Transformation Notes | Problems with Mapping | Notes (Uncategorized) | Milestone |
 |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
 | | 490 | SERIES STATEMENT (R) | Series tracing policy | * | | Undefined | * | | | | a, x, v | | | | | | | | http://rdaregistry.info/Elements/m/P30106 | has series statement | structured description | Chose not to use sub-properties because number of conditions is not sustainable for transformation. MARC does not have separate subfields for each element. Chose to retain MARC subfields when ISBD punctuation is absent in order to maintain structure of description. | when LDR 18 = a or i, remove marc subfields and rely on ISBD punctuation. When LDR 18=c, retain marc subfield codes to separate pieces of information | | | |
 
 ## General Rules
 - If not applicable, leave blank.
 - To indicate "any number 0-9" use 0-9.
 - To indicate "any value" use \*.
 - Notes should be initialed and dated, with separate notes in the same column/row separated by ;
 ### MARC tag formatting
 - 3 digit tag,
 - followed by space,
 - followed by indicators (blank indicators use #),
 - followed by either...
   - _for subfields:_
     - space, then $\[letter or number\]
   - _for character positions:_
     - /\[number\]
 #### Examples:
 - 264 #1 $c
 - 007/07
 
 ## Not Mapped
| Example | Details |
|---|---|
| x | If field should be left out of mapping for any reason, mark this field with "x". |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCField
| Example | Details |
|---|---|
| 250 | Main MARC tag. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_
 
 ## MARCFieldLabel
| Example | Details |
|---|---|
| EDITION STATEMENT (R) | Label for MARC tag. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_
 
 ## MARCInd1Label
| Example | Details |
|---|---|
| Undefined | Label for the first indicator (_not_ individual values). |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCInd1Value
| Example | Details |
|---|---|
| * | Value for the first indicator. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCInd1ValueLabel
| Example | Details |
|---|---|
| \[blank\] | Label for the value of the first indicator |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCInd2Label
| Example | Details |
|---|---|
| Undefined | Label for the second indicator (_not_ individual values). |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCInd2Value
| Example | Details |
|---|---|
| * | Value for the second indicator. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCInd2ValueLabel
| Example | Details |
|---|---|
| \[blank\] | Label for individual MARC second indicator values. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## CharacterPosition
| Example | Details |
|---|---|
| 0 |  |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## CharacterPositionLabel
| Example | Details |
|---|---|
| category of material | Label for the character position in the previous column (_not_ the value) |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCSubfield
| Example | Details |
|---|---|
| a | Do not include symbols; just the letter/number. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCSubfieldLabel
| Example | Details |
|---|---|
| Edition statement (NR) | Label for the subfield (_not_ for individual values). |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## CodeValue
| Example | Details |
|---|---|
| c | For coded fields, such as 007, where MARC has specified the meanings, the code itself goes here. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## CodeValueLabel
| Example | Details |
|---|---|
| \[blank\] | Label for the specific code indicated in previous column. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCTagCondition1
| Example | Details |
|---|---|
| 264 00 $b | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. **This should represent A** for the _first_ layer of conditions. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Condition1Value
| Example | Details |
|---|---|
| University of Washington | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. **This should represent A1** of the _first_ layer of conditions. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## MARCTagCondition2
| Example | Details |
|---|---|
| 007/00 | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. This should represent **A** of the _second_ layer of conditions. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Condition2Value
| Example | Details |
|---|---|
| m | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. This should represent **A1** of the _second_ layer of conditions. If more conditions are needed, add another pair of columns for "MARCTagCondition3" and "Condition3Values" and so on. Do not express multiple conditions in one column. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## RDA Registry URI
| Example | Details |
|---|---|
| <http://rdaregistry.info/Elements/m/P30107> | Full URI for the RDA Registry property the MARC maps to. Use constrained properties. If there is a one-to-many mapping, create a new row so that each row is limited to one URI. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## RDA Registry Label
| Example | Details |
|---|---|
| has edition statement | Label from the RDA Registry for the URI (for human readability). Do _not_ include quotes. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Recording Method
| Example | Details |
|---|---|
| One of the following: unstructured description, structured description, identifier, IRI | RDA Recording Method used in the MARC data, if known and if consistent. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Justification for Mapping
| Example | Details |
|---|---|
| We chose this property over that property because of reasons. | Notes on why a particular mapping was chosen. Not required, but recommended when multiple choices are possible. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Transformation Notes
| Example | Details |
|---|---|
| This property should be paired with these other ones to create multiple RDA/RDF statements that look like this: \[code example in .ttl\] | Notes on what the resulting RDA-RDF should look like. Not required. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Problems with Mapping
| Example | Details |
|---|---|
| Looks like this field with these conditions should map to some other property. | Notes on problems with the mapping. Not required. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_

 ## Notes (Uncategorized)
| Example | Details |
|---|---|
| This field is obsolete, but exists in legacy data so we should map it. -CEC 2021-09-29; Here's another note about another thing. - CEC 2021-10-01 | All notes that do not fall under another notes category. |

_[Return to top.](https://github.com/uwlib-cams/MARC2RDA/tree/main/Instructions#spreadsheet-instructions)_
