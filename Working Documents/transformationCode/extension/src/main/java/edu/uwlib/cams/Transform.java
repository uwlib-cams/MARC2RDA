package edu.uwlib.cams;

import net.sf.saxon.s9api.*;
import javax.xml.transform.stream.StreamSource;
import java.io.File;

public class Transform {
    public static void main(String[] args) throws SaxonApiException {
        Processor proc = new Processor(false);
        ExtensionFunction getFirstLevelTypes = new RdfPredicateExtractor();
        proc.registerExtensionFunction(getFirstLevelTypes);

        // Compile and run the transformation
        XsltCompiler compiler = proc.newXsltCompiler();
        XsltExecutable exec = compiler
                .compile(new StreamSource(new File("../m2r.xsl")));
        XsltTransformer transformer = exec.load();
        transformer.setSource(
                new StreamSource(new File("../test_input/5xx/518Test.xml")));

        // Configure the output destination
        Serializer out = proc
                .newSerializer(new File("../test_output/5xx/518Test-RDA.xml"));
        transformer.setDestination(out);

        transformer.transform();
    }
}
