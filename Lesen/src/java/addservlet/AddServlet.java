/*
 * author: Ingrid Farkas
 * project: Lesen
 * AddServlet.java : when the user clicks on the Submit button (add_form.jsp) this servlet is called
 */
package addservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import miscellaneous.LesenMethoden;

public class AddServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */ 
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sTitle = "Neues Buch"; // used for passing the title to the error_succ.jsp
        HttpSession hSession = request.getSession();
        
        String form_publ = request.getParameter("publisher"); // the text entered as the publisher
        String form_auth = request.getParameter("author"); // the text entered as the author
        String form_title = request.getParameter("title"); // the text entered as the title
        String form_isbn = request.getParameter("isbn"); // the text entered as the isbn 
        String form_price = request.getParameter("price"); // the text entered as the price
        String form_pages = request.getParameter("pages"); // the text entered as pages
        String form_categ = request.getParameter("category"); // the choice of the category
        String form_descr = request.getParameter("descr"); // the text entered as the description
        String form_yrpublished = request.getParameter("yrpublished"); // the text entered as the year when published 
        
        // deleteSpaces: removes space characters from the begining and end of the string, and replaces 2 or more white spaces with single space
        // inside of the string
        form_title = LesenMethoden.deleteSpaces(form_title);
        form_auth = LesenMethoden.deleteSpaces(form_auth);
        form_isbn = LesenMethoden.deleteSpaces(form_isbn);
        form_price = LesenMethoden.deleteSpaces(form_price);
        form_pages = LesenMethoden.deleteSpaces(form_pages);
        form_descr = LesenMethoden.deleteSpaces(form_descr);
        form_publ = LesenMethoden.deleteSpaces(form_publ);
        form_yrpublished = LesenMethoden.deleteSpaces(form_yrpublished);
        
        // addBacksl replaces every occurence of \ with \\\\ and replaces every occurence of ' with \\'
        form_title = LesenMethoden.addBacksl(form_title);
        form_auth = LesenMethoden.addBacksl(form_auth);
        form_descr = LesenMethoden.addBacksl(form_descr);
        form_publ = LesenMethoden.addBacksl(form_publ);
        
        // method addNewBook adds a new book to the table book (returns a String based on which one the error_succ.jsp shows the message)
        String sMessage = AddDAO.addNewBook(hSession, form_title, form_auth, form_publ, form_isbn, form_price, form_pages, form_categ, form_descr, form_yrpublished);
        
        // depending on the value returned by the method addNewBook determine sTitle
        //if ((sMessage.equals("ERR_ADD")) || (sMessage.equals("ERR_ADD_EXISTS"))) {
            sTitle = "Neues Buch"; // used for passing the title to the JSP
        //} else if (sMessage.equals("SUCC_ADD")) {
            // sTitle = "Neues Buch"; // used for passing the title to the JSP
        //}
        
        hSession.setAttribute("source_name", "Neues Buch"); // on which page I am now
        hSession.setAttribute("message", sMessage); // setting the attribute message to the value sMessage
        hSession.setAttribute("title", sTitle); // setting the attribute message to the value sTitle
        response.sendRedirect("error_succ.jsp"); // redirects the response to error_succ.jsp                        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
