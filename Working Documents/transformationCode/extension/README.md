# Extensions for MARC2RDA

MARC2RDA Extensions is a Java-based project designed to extend the capabilities of the [MARC2RDA](https://github.com/uwlib-cams/MARC2RDA). It enables the Oxygen XML Editor to execute Java through Saxon, facilitating the extraction of RDF types from various URIs.

## Extensions List

### RdfPredicateExtractor

RdfPredicateExtractor is a Java application designed to fetch RDF models from various URI domains and extract the first-level RDF types of a given resource. It handles different domain-specific rules for constructing RDF URLs and supports multiple content types.

## Prerequisites

- Java Development Kit (JDK) 11 or higher
- Maven 22 or higher https://maven.apache.org/download.cgi

## Getting Started

### Build the project

```sh
mvn clean install
```

### exec extensions and run transformation manually

```sh
mvn exec:java -Prun
```

### Local development

VS Code is recommend for this project...TBD
```