# Spreadsheet Instructions
_Last updated 18 January 2022_
## Table of Contents
 - [General Rules](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#General_Rules)
 - [Not Mapped](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Not_Mapped)
 - [MARCField](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCField)
 - [MARCFieldLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCFieldLabel)
 - [MARCInd1Label](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCInd1Label)
 - [MARCInd1Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCInd1Value)
 - [MARCInd1ValueLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCInd1ValueLabel)
 - [MARCInd2Label](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCInd2Label)
 - [MARCInd2Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCInd2Value)
 - [MARCInd2ValueLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCInd2ValueLabel)
 - [CharacterPosition](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#CharacterPosition)
 - [CharacterPositionLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#CharacterPositionLabel)
 - [MARCSubfield](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCSubfield)
 - [MARCSubfieldLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCSubfieldLabel)
 - [CodeValue](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#CodeValue)
 - [CodeValueLabel](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#CodeValueLabel)
 - [MARCTagCondition1](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCTagCondition1)
 - [Condition1Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Condition1Value)
 - [MARCTagCondition2](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#MARCTagCondition2)
 - [Condition2Value](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Condition2Value)
 - [RDA Registry URI](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#RDA_Registry_IRI)
 - [RDA Registry Label](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#RDA_Registry_Label)
 - [Recording Method](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Recording_Method)
 - [Justification for Mapping](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Justification_for_Mapping)
 - [Transformation Notes](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Transformation_Notes)
 - [Problems with Mapping](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Problems_with_Mapping)
 - [Notes (Uncategorized)](https://github.com/uwlib-cams/MARC2RDA/tree/master/Instructions#Notes_Uncategorized)
 
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

 ## MARCField
| Example | Details |
|---|---|
| 250 | Main MARC tag. |
 
 ## MARCFieldLabel
| Example | Details |
|---|---|
| EDITION STATEMENT (R) | Label for MARC tag. |
 
 ## MARCInd1Label
| Example | Details |
|---|---|
| Undefined | Label for the first indicator (_not_ individual values). |

 ## MARCInd1Value
| Example | Details |
|---|---|
| * | Value for the first indicator. |

 ## MARCInd1ValueLabel
| Example | Details |
|---|---|
| \[blank\] | Label for the value of the first indicator |

 ## MARCInd2Label
| Example | Details |
|---|---|
| Undefined | Label for the second indicator (_not_ individual values). |

 ## MARCInd2Value
| Example | Details |
|---|---|
| * | Value for the second indicator. |

 ## MARCInd2ValueLabel
| Example | Details |
|---|---|
| \[blank\] | Label for individual MARC second indicator values. |

 ## CharacterPosition
| Example | Details |
|---|---|
| 0 |  |

 ## CharacterPositionLabel
| Example | Details |
|---|---|
| category of material | Label for the character position in the previous column (_not_ the value) |

 ## MARCSubfield
| Example | Details |
|---|---|
| a | Do not include symbols; just the letter/number. |

 ## MARCSubfieldLabel
| Example | Details |
|---|---|
| Edition statement (NR) | Label for the subfield (_not_ for individual values). |

 ## CodeValue
| Example | Details |
|---|---|
| c | For coded fields, such as 007, where MARC has specified the meanings, the code itself goes here. |

 ## CodeValueLabel
| Example | Details |
|---|---|
| \[blank\] | Label for the specific code indicated in previous column. |

 ## MARCTagCondition1
| Example | Details |
|---|---|
| 264 00 $b | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. **This should represent A** for the _first_ layer of conditions. |

 ## Condition1Value
| Example | Details |
|---|---|
| University of Washington | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. **This should represent A1** of the _first_ layer of conditions. |

 ## MARCTagCondition2
| Example | Details |
|---|---|
| 007/00 | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. This should represent **A** of the _second_ layer of conditions. |

 ## Condition2Value
| Example | Details |
|---|---|
| m | Mapping often needs to specify "**If A equals A1, then A maps to B**". (B=RDA Registry URI) Sometimes multiple layers of these statements are needed to achieve sufficient specificity. This should represent **A1** of the _second_ layer of conditions. If more conditions are needed, add another pair of columns for "MARCTagCondition3" and "Condition3Values" and so on. Do not express multiple conditions in one column. |

 ## RDA Registry URI
| Example | Details |
|---|---|
| <http://rdaregistry.info/Elements/m/P30107> | Full URI for the RDA Registry property the MARC maps to. Use constrained properties. If there is a one-to-many mapping, create a new row so that each row is limited to one URI. |

 ## RDA Registry Label
| Example | Details |
|---|---|
| has edition statement | Label from the RDA Registry for the URI (for human readability). Do _not_ include quotes. |

 ## Recording Method
| Example | Details |
|---|---|
| One of the following: unstructured description, structured description, identifier, IRI | RDA Recording Method used in the MARC data, if known and if consistent. |

 ## Justification for Mapping
| Example | Details |
|---|---|
| We chose this property over that property because of reasons. | Notes on why a particular mapping was chosen. Not required, but recommended when multiple choices are possible. |

 ## Transformation Notes
| Example | Details |
|---|---|
| This property should be paired with these other ones to create multiple RDA/RDF statements that look like this: \[code example in .ttl\] | Notes on what the resulting RDA-RDF should look like. Not required. |

 ## Problems with Mapping
| Example | Details |
|---|---|
| Looks like this field with these conditions should map to some other property. | Notes on problems with the mapping. Not required. |

 ## Notes (Uncategorized)
| Example | Details |
|---|---|
| This field is obsolete, but exists in legacy data so we should map it. -CEC 2021-09-29; Here's another note about another thing. - CEC 2021-10-01 | All notes that do not fall under another notes category. |