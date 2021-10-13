package com.mitchseymour.thrift.parser;

import com.mitchseymour.thrift.parser.ast.ThriftAst;
import com.mitchseymour.thrift.parser.ast.Nodes;
import org.parboiled.Parboiled;
import org.parboiled.parserunners.ReportingParseRunner;
import org.parboiled.support.ParsingResult;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class ThriftParser {

    public static ParsingResult<?> parseThriftFile(String file) throws IOException {
        String idl = readFile(file);
        return apply(idl);
    }

    public static Optional<Nodes.DocumentNode> parseThriftFileAst(String file) throws IOException {
        String idl = readFile(file);
        return applyAst(idl);
    }

    public static Map<String, Nodes.DocumentNode> parseThriftFileAst2Map(String file) throws IOException {
        String idl = readFile(file);
        return applyAst2Map(idl);
    }

    public static String readFile(String path)
            throws IOException {
        InputStream in = ThriftParser.class.getResourceAsStream(path);
        BufferedReader buffer = new BufferedReader(new InputStreamReader(in));
        String line;
        String lines = "";
        while ((line = buffer.readLine()) != null) {
            lines += String.format("%s\n", line);
        }
        return lines;
    }

    public static ParsingResult<?> apply(String input) {
        ThriftIdl parser = Parboiled.createParser(ThriftIdl.class);
        input = Preprocessor.stripComments(input);
        ParsingResult<?> result = new ReportingParseRunner(parser.Document()).run(input);
        return result;
    }

    public static Optional<Nodes.DocumentNode> applyAst(String input) throws IOException {
        ThriftAst thriftAst = new ThriftAst();
        Optional<Nodes.DocumentNode> document = thriftAst.parseThriftIdl(input);
        if (document.isPresent()) {
            Nodes.DocumentNode d = document.get();
            List<String> includes = d.getIncludeFiles();
            if (includes.size() == 0) {
                return document;
            }
            // we need to add the contents of the includes files
            for (String includeFile : includes) {
                Optional<Nodes.DocumentNode> includedDocument = parseThriftFileAst("/" + includeFile);
                if (!includedDocument.isPresent()) {
                    // maybe should throw exception here?
                    continue;
                }
                d.addHeaders(includedDocument.get().headers);
                d.addDefinitions(includedDocument.get().definitions);
            }
            return Optional.of(d);
        }
        return document;
    }

    /**
     * get AST Result.
     * Each thrift file will be parsed as a document and put on a result map.
     * @param input
     * @return
     * @throws IOException
     */
    public static Map<String,Nodes.DocumentNode> applyAst2Map(String input) throws IOException {
        Map<String,Nodes.DocumentNode> map = new LinkedHashMap<>();
        ThriftAst thriftAst = new ThriftAst();
        Optional<Nodes.DocumentNode> document = thriftAst.parseThriftIdl(input);
        if (document.isPresent()) {
            Nodes.DocumentNode d = document.get();
            map.put("this",d);
            List<String> includes = d.getIncludeFiles();
            if (includes.size() == 0) {
                return map;
            }
            // we need to add the contents of the includes files
            for (String includeFile : includes) {
                Optional<Nodes.DocumentNode> includedDocument = parseThriftFileAst("/" + includeFile);
                if (!includedDocument.isPresent()) {
                    // maybe should throw exception here?
                    continue;
                }
                //get the fileName
                if (includeFile.contains(".")) {
                    includeFile = includeFile.split("\\.")[0];
                }
                map.put(includeFile,includedDocument.get());
            }
            return map;
        }
        return map;
    }
}
