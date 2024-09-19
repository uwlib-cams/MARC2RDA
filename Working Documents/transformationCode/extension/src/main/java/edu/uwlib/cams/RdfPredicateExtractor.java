package edu.uwlib.cams;

import net.sf.saxon.s9api.*;
import org.apache.jena.rdf.model.*;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RdfPredicateExtractor implements ExtensionFunction {

    @Override
    public QName getName() {
        return new QName("uwlib-cams/MARC2RDA/extensions", "getFirstLevelTypes");
    }

    @Override
    public SequenceType getResultType() {
        return SequenceType.makeSequenceType(ItemType.STRING, OccurrenceIndicator.ONE);
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[] { SequenceType.makeSequenceType(ItemType.STRING, OccurrenceIndicator.ONE) };
    }

    @Override
    public XdmValue call(XdmValue[] arguments) throws SaxonApiException {
        String uri = ((XdmAtomicValue) arguments[0].itemAt(0)).getStringValue();
        String result = getFirstLevelTypes(uri);
        return new XdmAtomicValue(result);
    }

    public static String getFirstLevelTypes(String uri) {
        StringBuilder result = new StringBuilder();
        Resource resource = getResource(uri);

        if (resource != null) {
            result.append(printFirstLevelTypes(resource));
        }

        return result.toString();
    }

    private static Resource getResource(String uri) {
        String baseUri = uri.substring(uri.indexOf("://") + 3);
        String domain = baseUri.split("/")[0];
        Model model = null;
        Resource resource = null;

        switch (domain) {
            case "data.cerl.org":
                model = tryFetchRdfModel("https://" + baseUri + "?_format=rdfxml");
                resource = model.getResource(uri);
                break;
            case "dbpedia.org":
                model = tryFetchRdfModel(
                        "https://dbpedia.org/data/" + uri.substring(uri.lastIndexOf('/') + 1) + ".rdf");
                resource = model.getResource(uri);
                break;
            case "id.worldcat.org":
                model = tryFetchRdfModel("https://" + baseUri + ".rdf.xml");
                resource = model.getResource(uri);
                break;
            case "sws.geonames.org":
                model = tryFetchRdfModel("https://" + baseUri + "about.rdf");
                resource = model.getResource(uri);
                break;
            case "d-nb.info":
                model = tryFetchRdfModel("https://" + baseUri + "/about/rdf");
                resource = model.getResource("https://" + baseUri);
                break;
            case "purl.obolibrary.org":
                model = tryFetchRdfModel("https://ontobee.org/ontology/rdf/GSSO?iri=" + uri);
                resource = model.getResource(uri);
                break;
            case "w3id.org":
                model = tryFetchRdfModel(
                        "https://api.haf.vhmml.org/" + baseUri.substring(baseUri.indexOf("/") + 1).replace("haf/", "")
                                + "/export/xml");
                resource = model.getResource("https://w3id.org/" + baseUri.substring(baseUri.indexOf("/") + 1));
                break;
            case "haf.vhmml.org":
                model = tryFetchRdfModel(
                        "https://api.haf.vhmml.org/" + baseUri.substring(baseUri.indexOf("/") + 1) + "/export/xml");
                resource = model.getResource("https://w3id.org/haf/" + baseUri.substring(baseUri.indexOf("/") + 1));
                break;
            case "lod.nal.usda.gov":
                model = tryFetchRdfModel(
                        "https://lod.nal.usda.gov/rest/v1/nalt/data?uri=" + encodeUri(uri)
                                + "&format=application/rdf%2Bxml");
                resource = model.getResource(uri);
                break;
            case "metadataregistry.org":
                // use http instead of https
                model = tryFetchRdfModel("http://" + baseUri + ".rdf");
                resource = model.getResource(uri);
                break;
            case "pleiades.stoa.org":
                model = tryFetchRdfModel("https://" + baseUri + "/rdf");
                resource = model.getResource(uri);
                break;
            case "rdaregistry.info":
                Pattern pattern = Pattern.compile("rdaregistry.info/([^/]+/[^/]+)(/|$)");
                Matcher matcher = pattern.matcher(baseUri);

                if (matcher.find()) {
                    model = tryFetchRdfModel("https://www.rdaregistry.info/xml/" + matcher.group(1) + ".xml");
                    resource = model.getResource(uri);
                }
                break;
            case "metadata.un.org":
                model = tryFetchRdfModel("https://" + baseUri + ".xml");
                resource = model.getResource(uri);
                break;
            case "vocabularies.unesco.org":
                model = tryFetchRdfModel(
                        "https://vocabularies.unesco.org/browser/rest/v1/thesaurus/data?uri=" + encodeUri(uri)
                                + "&format=application/rdf%2Bxml");
                resource = model.getResource(uri);
                break;
            case "isni.org":
                // downloading rdf by the url is unavailable, need to parse manually
                break;
            case "www.bbc.co.uk":
            case "homosaurus.org":
            case "resource.manto.unh.edu":
            case "musicbrainz.org":
            case "orcid.org":
            case "n2t.net":
            case "rism.online":
            case "entities.oclc.org":
                break;
            default:
                model = tryFetchRdfModel("https://" + baseUri + ".rdf");
                resource = model.getResource(uri);
        }
        return resource;
    }

    private static Model tryFetchRdfModel(String rdfUri) {
        try {
            URL url = new URL(rdfUri);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setInstanceFollowRedirects(false); // Handle redirects manually

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_MOVED_PERM
                    || responseCode == HttpURLConnection.HTTP_MOVED_TEMP
                    || responseCode == HttpURLConnection.HTTP_SEE_OTHER) { // Handle 303 status code
                String newUrl = connection.getHeaderField("Location");
                if (newUrl != null) {
                    URI baseUri = url.toURI();
                    URI resolvedUri = baseUri.resolve(newUrl);
                    return tryFetchRdfModel(resolvedUri.toString());
                }
            }

            String contentType = connection.getContentType();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                return null;
            }

            if (contentType == null) {
                // expected content types:
                // application/rdf+xml
                // application/xml
                // text/xml
                return null;
            }

            InputStream in = connection.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
            in.close();
            String rdfContent = sb.toString();

            Model model = ModelFactory.createDefaultModel();
            model.read(new StringReader(rdfContent), null);
            return model;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static String printFirstLevelTypes(Resource resource) {
        StmtIterator stmtIterator = resource.listProperties();
        StringBuilder result = new StringBuilder();

        while (stmtIterator.hasNext()) {
            Statement stmt = stmtIterator.nextStatement();
            if (stmt.getPredicate().getURI().equals("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")) {
                Resource type = stmt.getObject().asResource();
                result.append(type.getURI()).append("\n");
            }
        }
        return result.toString();
    }

    private static String encodeUri(String uri) {
        try {
            return URLEncoder.encode(uri, StandardCharsets.UTF_8.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
