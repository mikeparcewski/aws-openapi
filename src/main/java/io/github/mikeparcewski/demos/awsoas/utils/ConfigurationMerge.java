package io.github.mikeparcewski.demos.awsoas.utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import org.springframework.core.io.ClassPathResource;

/**
 * quick hack to merge yaml configuration files
 */
public class ConfigurationMerge {

  /**
   * expects three files (in order) and merges them to form cloudformation script.
   * Param 1 is the OpenAPI spec
   * Param 2 is the AWS Extensions to the OpenAPI spec and is merged into the OpenAPI spec (step 1)
   * Param 3 describe the rest of the AWS resources and the merged OpenSpec (from step 1) is appended to the Body element.
   * @param args collection of file locations
   * @throws Exception
   */
  public static void main(String[] args) throws Exception {

    if (args.length < 3) {
      System.out.println("Please provide all 3 files");
      System.exit(1);
    }

    ObjectMapper jsonWriter = new ObjectMapper();
    ObjectMapper updater = new ObjectMapper();

    // merge openapi and aws extensions
    JsonNode openapi = readJson(args[1]);
    JsonNode o = (JsonNode)updater.readerForUpdating(openapi).readValue(readJson(args[2]));


    // modify openapi structure to match aws config
    JsonNode awsCfn = readJson(args[0]);
    ObjectNode aws = (ObjectNode)awsCfn.get("Resources").get("RestAPIv2").get("Properties");
    aws.set("Body", o);
    String ret = jsonWriter.writeValueAsString(awsCfn);

    // write out the config file
    Path path = Paths.get("target/aws-config.json");
    Files.write(path, ret.getBytes());

  }

  /**
   * converts YAML to json.
   * @param resourcePath the resource path of the file
   * @return jsonnode parsed from YAML file
   */
  public static JsonNode readJson(String resourcePath) throws Exception {

    ClassPathResource resource = new ClassPathResource(resourcePath);
    try ( BufferedReader reader = new BufferedReader(
        new InputStreamReader(resource.getInputStream())) ) {
      String str = reader.lines().collect(Collectors.joining("\n"));
      ObjectMapper jsonWriter = new ObjectMapper();
      return jsonWriter.readTree(str);
    }

  }

}
