# Extensions for MARC2RDA

MARC2RDA Extensions is a Java-based project designed to extend the capabilities of the [MARC2RDA](https://github.com/uwlib-cams/MARC2RDA). It enables the Oxygen XML Editor to execute Java through Saxon, facilitating the extraction of RDF types from various URIs.

## Extensions List

### RdfPredicateExtractor

RdfPredicateExtractor is a Java application designed to fetch RDF models from various URI domains and extract the first-level RDF types of a given resource. It handles different domain-specific rules for constructing RDF URLs and supports multiple content types.

## Extensions Prerequisites

- Java Development Kit (JDK) 11 or higher
- Maven 22 or higher https://maven.apache.org/download.cgi

## Getting Started

### Build the project using command line

Before building and executing extensions, ensure that you are under the `extension` directory. You can use the `cd` command to change the working directory to the `extension` directory before executing the following commands.

```sh
mvn clean install
```

### exec extensions and run transformation manually

We recommend executing XSLT extensions with Oxygen XML Editor (with Saxon HE). Alternatively, you can transform with extensions via the command line by the following command. The configuration can be changed in the `extension/pom.xml` file. The entry, input, and output file can be updated in `extension/src/main/java/edu/uwlib/cams/Transform.java`.

```sh
mvn exec:java -Prun
```
