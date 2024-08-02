package edu.uwlib.cams;

import org.apache.jena.rdf.model.*;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.StringReader;

public class RdfPredicateExtractor {
    public static void main(String[] args) throws Exception {
        // for debugging purposes
        System.out.println(getFirstLevelTypes("http://dbpedia.org/resource/British_Library"));
    }

    public static String getFirstLevelTypes(String uri) {
        Model model = fetchRdfModel(uri);
        StringBuilder result = new StringBuilder();

        if (model != null) {
            Resource resource = model.getResource(uri);

            if (resource != null) {
                result.append(printFirstLevelTypes(resource));
            }
        }
        return result.toString();
    }

    private static Model fetchRdfModel(String uri) {
        String baseUri = uri.substring(uri.indexOf("://") + 3);
        String domain = baseUri.split("/")[0];
        Model model = null;

        switch (domain) {
            case "data.cerl.org":
                model = tryFetchRdfModel("https://" + baseUri + "?_format=rdfxml");
                break;
            case "www.bbc.co.uk":
                // TODO: need to parse .ttl
            case "dbpedia.org":
                model = tryFetchRdfModel(
                        "https://dbpedia.org/data/" + uri.substring(uri.lastIndexOf('/') + 1) + ".rdf");
                break;
            default:
                model = tryFetchRdfModel("https://" + baseUri + ".rdf");
        }
        return model;
    }

    private static Model tryFetchRdfModel(String rdfUri) {
        try {
            URL url = new URL(rdfUri);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setInstanceFollowRedirects(true); // Follow redirects if any

            int responseCode = connection.getResponseCode();
            String contentType = connection.getContentType();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                return null;
            }

            if (contentType == null || !contentType.contains("application/rdf+xml")) {
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
}
