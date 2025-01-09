# Film Festivals XML Collection

A structured XML collection of international film festival information, with validation rules and transformation stylesheets for web and print output. The project demonstrates XML data structuring, validation, and transformation capabilities.

## Features
- Structured XML document containing major international film festivals
- XML Schema (XSD) for data validation 
- Schematron rules for advanced business logic validation
- XSLT transformation to generate responsive HTML website
- XSLT transformation to generate formatted PDF reports
- Support for festival details including:
  - Basic information (dates, locations, venues)
  - Awards and winners
  - Special guests
  - Ticket information
  - Partner organizations
  - Festival logos and images

## File Structure
- `FF.xml` - Main XML document containing film festival data
- `FFSchema.xsd` - XML Schema definition for data structure validation
- `FFSchematron.sch` - Schematron rules for business logic validation
- `FilmFestivalsToHtml.xslt` - XSLT stylesheet for HTML output
- `FilmFestivalsToPdf.xslt` - XSLT stylesheet for PDF output

## Technologies
- XML
- XSD (XML Schema Definition)
- Schematron
- XSLT 2.0
- XPath
- FO (Formatting Objects)

## Usage
The XML document can be validated and transformed using any standard XML processor that supports XSLT 2.0 and Schematron. The XSLT transformations will generate:
- A responsive HTML website with festival details and navigation
- A formatted PDF document containing comprehensive festival information

## Author
Matěj Krejčí
