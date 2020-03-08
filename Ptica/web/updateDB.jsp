<%-- 
    Document   : updateDB called from update_form.jsp
    Created on : 14-Mar-2019, 04:09:42
    Author     : Ingrid Farkas
    Project    : Ptica
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="connection.ConnectionManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="miscellaneous.PticaMetodi"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/templatecss.css" type="text/css" rel="stylesheet"/>
        <title>Ptica - Update Book</title>
        
        <%@ include file="header.jsp"%>
    </head>
    
    <body>
        <%!
            // for the publisher named publ_name returns the publisher id
            String determinePublID(String publ_name, Statement stmt) { 
                try {
                    // creating the query SELECT publ_id, city FROM publisher WHERE publ_name='...' AND city='...';
                    String publid = ""; // publisher ID
                    // creating the query string
                    String rs_query = "SELECT publ_id"; 
                    rs_query += " FROM publisher WHERE publ_name='" + publ_name + "'";
                    rs_query += ";";   
                    
                    // running the query
                    ResultSet rs = stmt.executeQuery(rs_query);
                    
                    // if the query returned some records, retrieve the publisher id 
                    if (rs.next()) 
                        publid = rs.getString("publ_id");
                    return publid;
                } catch (SQLException ex) {
                    return ""; // if an exception occurred return publisher id = ""
                }
            }
            
            // for the author named auth_name returns the author id
            String determineAuthID(String auth_name, Statement stmt) { 
                try {
                    // creating the query SELECT au_id FROM author WHERE au_name='...';
                    String authid = ""; // author ID
                    // creating the query string
                    String rs_query = "SELECT au_id "; 
                    rs_query += "FROM author WHERE au_name='" + auth_name + "'";
                    rs_query += ";";   
                    // running the query
                    ResultSet rs = stmt.executeQuery(rs_query);
                    // if the query returned some records, retrieve the author id 
                    if (rs.next()) 
                        authid = rs.getString("au_id");
                    return authid;
                } catch ( SQLException ex) {
                    return ""; // if an exception occurred return author id = ""
                }
            }
        %>   
        
        <%
            // the session to which I am going to add attributes
            HttpSession hSession = request.getSession();
            try { 
                String form_title = request.getParameter("title"); // the text entered as the title
                String form_auth = request.getParameter("author"); // the text entered as the author
                String form_isbn = request.getParameter("isbn"); // the text entered as the isbn 
                String form_price = request.getParameter("price"); // the text entered as the price
                String form_pages = request.getParameter("pages"); // the text entered as pages
                String form_categ = request.getParameter("category"); // the choice of the category
                String form_descr = request.getParameter("descr"); // the text entered as the description
                String form_publ = request.getParameter("publisher"); // the text entered as the publisher
                String form_yrpublished = request.getParameter("yrpublished"); // the text entered as the year when published 

                // deleteSpaces: removes space characters from the begining and end of the string, and replaces 2 or more white spaces 
                // with single space inside of the string
                form_title = PticaMetodi.deleteSpaces(form_title);
                form_auth = PticaMetodi.deleteSpaces(form_auth);
                form_isbn = PticaMetodi.deleteSpaces(form_isbn);
                form_price = PticaMetodi.deleteSpaces(form_price);
                form_pages = PticaMetodi.deleteSpaces(form_pages);
                form_publ = PticaMetodi.deleteSpaces(form_publ);
                form_descr = PticaMetodi.deleteSpaces(form_descr);

                // addBacksl replaces every occurence of \ with \\\\ and replaces every occurence of ' with \\'
                form_title = PticaMetodi.addBacksl(form_title);
                form_auth = PticaMetodi.addBacksl(form_auth);
                form_publ = PticaMetodi.addBacksl(form_publ);
                form_descr = PticaMetodi.addBacksl(form_descr);

                Connection con = ConnectionManager.getConnection(); //connecting to database ;
                Statement stmt = con.createStatement();

                String rs_query=""; 
                ResultSet rs; // object where the query's results are stored
                String auid = ""; // author id
                String publid = ""; // publisher id  
                String bookid = ""; // book id
                boolean exists_val = false; // the value was entered in the input field

                // DETERMINING the PUBLISHER ID 
                if (!((form_publ.equalsIgnoreCase("")))) {
                    // determinePublID : creating and runnung the query SELECT publ_id, city FROM publisher WHERE publ_name='...' AND city='...';
                    publid = determinePublID(form_publ, stmt); // determine the publisher ID for that publisher (in the city)

                    if (publid.equals("")) { // the publisher with that name doesn't exist, add the new publisher to the publisher table
                        // creating the string "INSERT INTO publisher(publ_name, city) VALUES ('...', '...');
                        // and executing the query
                        rs_query = "INSERT INTO publisher(publ_name";
                        rs_query += ") VALUES ('" + form_publ + "'";
                        rs_query += ");";

                        PreparedStatement preparedStmt = con.prepareStatement(rs_query);
                        preparedStmt.execute();

                        // retrieving the publ_id for the inserted publisher
                        publid = determinePublID(form_publ, stmt);
                    }
                }

                // DETERMINING the AUTHOR ID 
                if (!((form_auth.equalsIgnoreCase("")))) {
                    // determineAuthID : creating and running the query SELECT au_id FROM author WHERE au_name='...';
                    auid = determineAuthID(form_auth, stmt); // determine the author ID for that author
                    // if the author with that name doesn't exist, add it to the author table
                    if (auid.equals("")) { 
                        // creating the string "INSERT INTO author(au_name) VALUES ('...');
                        // and executing the query
                        rs_query = "INSERT INTO author(au_name) ";
                        rs_query += "VALUES ('" + form_auth + "');";

                        PreparedStatement preparedStmt = con.prepareStatement(rs_query);
                        preparedStmt.execute();
                        // retrieving the publ_id for the inserted publisher
                        auid = determineAuthID(form_auth, stmt);
                    }
                }

                // read the book ID from the session
                bookid = String.valueOf(hSession.getAttribute("bookid"));

                // TABLE book : query update
                boolean is_added = false; // is the name of any column added to the update st.
                String query = "update book set ";

                // if there is new name of the author, add to the query au_id = auid
                // auid was determined above by calling the method determineAuthID(form_auth, stmt)
                if (!((form_auth.equalsIgnoreCase("")))) {
                    query += "au_id='" + auid + "'";
                    is_added = true; // the name of the column was added to the update statement
                }

                // if there is new name of the publisher add to the query publ_id = publid
                // publid was determined above by calling the method determinePublID(form_publ, stmt)
                if (!(form_publ.equalsIgnoreCase("")))  {
                    // if I added au_id = '...' then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "publ_id='" + publid + "'";
                    is_added = true; // the name of the column was added to the update statement
                }

                // if there is a new title add to the query title = form_title
                if (!((form_title.equalsIgnoreCase("")))) {
                    // if I added publ_id = '...' ( or some other column ) then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "title='" + form_title + "'";
                    is_added = true;
                }

                // if there is a new isbn add to the query isbn = form_isbn
                if (!((form_isbn.equalsIgnoreCase("")))) {
                    // if I added title='...' then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "isbn='" + form_isbn + "'";
                    is_added = true;
                }

                // if there is a new price add to the query price = form_price
                form_price = form_price.replaceAll(" ", "");
                if (!((form_price.equalsIgnoreCase("")))) {
                    // if I added isbn='...' (or some other column) then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "price='" + form_price + "'";
                    is_added = true;
                }

                // if there is a new pages add to the query pages = form_pages
                if (!((form_pages.equalsIgnoreCase("")))) {
                    // if I added price='...' (or some other column) then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "pages='" + form_pages + "'";
                    is_added = true;
                }

                // if there is a new category add to the query category = form_categ
                if (!((form_categ.equalsIgnoreCase("")))) {
                    // if I added pages='...' (or some other column) then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "category='" + form_categ + "'";
                    is_added = true;
                }

                // if there is a new descr add to the query descr = form_descr
                if (!((form_descr.equalsIgnoreCase("")))) {
                    // if I added category='...' (or some other column) then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "descr='" + form_descr + "'";
                    is_added = true;
                }

                // if there is a new year published add to the query publ_year = form_yrpublished
                if (!((form_yrpublished.equalsIgnoreCase("")))) {
                    // if I added category='...' (or some other column) then add the comma
                    if (is_added){
                        query += ",";
                    }
                    query += "publ_year='" + form_yrpublished + "'";
                    is_added = true;
                }

                // adding to the query where book_id = 'bookid'
                query += " where book_id='" + bookid + "';";           

                PreparedStatement preparedStmt = con.prepareStatement(query);
                preparedStmt.execute();

                // Show the page with the message that the book was successfully updated in the database
                hSession.setAttribute("source_name", "Update Book"); // on which page I am now
                String sTitle = "Update Book!"; // used for passing the title from one JSP script to the other
                String sMessage = "SUCC_UPDATE"; // used for passing the message from one JSP script to the other
                hSession.setAttribute("message", sMessage);
                hSession.setAttribute("title", sTitle);
                response.sendRedirect("error_succ.jsp"); // redirects the response to error_succ.jsp  
        %>
        
        <br>
        <br>
        
        <%
            out.print(" ");
        %>
             
        <%
            } catch(Exception e) { // if an exception occurred set the attributes
                String sTitle = "Error!"; // used for passing the title from one JSP script to the other
                String sMessage = "ERR_UPDATE"; // used for passing the message from one JSP script to the other
                hSession.setAttribute("source_name", "Update Book"); // on which page I am now
                hSession.setAttribute("message", sMessage); // setting the attribute message to the value sMessage
                hSession.setAttribute("title", sTitle); // setting the attribute message to the value sTitle
                response.sendRedirect("error_succ.jsp"); // redirects the response to error_succ.jsp 
            }
        %>
       
    <%@ include file="footer.jsp"%>
    </body>
</html>