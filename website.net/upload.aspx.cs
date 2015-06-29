using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class upload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        // this is called by a POST request ... so check that
            if (Request.HttpMethod == "POST")
            {
                System.Data.SqlClient.SqlConnection m_sqlConnection;

                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["picConnect"].ConnectionString;

                m_sqlConnection = new System.Data.SqlClient.SqlConnection(connStr);

                m_sqlConnection.Open();

                // prepare the statement
                System.Data.SqlClient.SqlCommand insertCmd = new System.Data.SqlClient.SqlCommand("addPicture", m_sqlConnection);
                insertCmd.CommandType = CommandType.StoredProcedure;

                string hostname = "_unknown_";
                if (Request.Params["hostname"] != null)
                    hostname = Request.Params["hostname"];

                insertCmd.Parameters.Add("@hostname", hostname);

                byte[] buffer = new byte[Request.InputStream.Length];
                Request.InputStream.Read(buffer, 0, buffer.Length);

                string b64 = System.Text.Encoding.Default.GetString(buffer);

                byte[] image = Convert.FromBase64String(b64);
                insertCmd.Parameters.Add("@pic", image);

                insertCmd.ExecuteNonQuery();

                m_sqlConnection.Close();
            }
 
            
    }
}