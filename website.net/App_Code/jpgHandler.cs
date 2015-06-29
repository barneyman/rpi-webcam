using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

using BumpKit;

/// <summary>
/// Summary description for jpgHandler
/// </summary>
/// 
namespace handlers
{



    public class jpgHandler : IHttpHandler
    {
        public jpgHandler()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ClearContent();
            // squirt it out
            context.Response.BufferOutput = false;


            System.Data.SqlClient.SqlConnection m_sqlConnection;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["picConnect"].ConnectionString;

            m_sqlConnection = new System.Data.SqlClient.SqlConnection(connStr);

            m_sqlConnection.Open();

            // prepare the statement
            System.Data.SqlClient.SqlCommand insertCmd = new System.Data.SqlClient.SqlCommand("getLatestPic", m_sqlConnection);
            insertCmd.CommandType = CommandType.StoredProcedure;

            System.Data.SqlClient.SqlDataReader read = insertCmd.ExecuteReader();

            if (read.Read())
            {

                context.Response.AddHeader("Content-Length", System.Convert.ToString(read["piclength"]));
                context.Response.AddHeader("Date", read.GetSqlDateTime(read.GetOrdinal("picDate")).ToString());//System.DateTime.Now.ToUniversalTime().ToString("R"));
                context.Response.AddHeader("Content-Type", "image/jpeg");

                // if its a get, then do it
                if (context.Request.HttpMethod == "GET")
                {
                    // wrap the bytes in a writer
                    using (System.IO.MemoryStream writer = new System.IO.MemoryStream((byte[])read.GetSqlBinary(read.GetOrdinal("pic"))))
                    {
                        writer.WriteTo(context.Response.OutputStream);
                    }
                }

                read.Close();


            }

            m_sqlConnection.Close();



        }
    }




    public class gifHandler : IHttpHandler
    {
        public gifHandler()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ClearContent();
            // squirt it out
            context.Response.BufferOutput = false;


            System.Data.SqlClient.SqlConnection m_sqlConnection;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["picConnect"].ConnectionString;

            m_sqlConnection = new System.Data.SqlClient.SqlConnection(connStr);

            m_sqlConnection.Open();

            // prepare the statement
            System.Data.SqlClient.SqlCommand insertCmd = new System.Data.SqlClient.SqlCommand("getPicRange", m_sqlConnection);
            insertCmd.CommandType = CommandType.StoredProcedure;

            System.Data.SqlClient.SqlDataReader read = insertCmd.ExecuteReader();

            System.IO.MemoryStream gif=new System.IO.MemoryStream();

            BumpKit.GifEncoder encoder = new GifEncoder(gif);

            encoder.FrameDelay = System.TimeSpan.FromMilliseconds(250);

            while (read.Read())
            {
                using (System.IO.MemoryStream image = new System.IO.MemoryStream((byte[])read.GetSqlBinary(read.GetOrdinal("pic"))))
                {
                    encoder.AddFrame(System.Drawing.Image.FromStream(image));
                }

            }

            context.Response.AddHeader("Content-Length", System.Convert.ToString(gif.Length));
            context.Response.AddHeader("Content-Type", "image/gif");

            gif.WriteTo(context.Response.OutputStream);

            m_sqlConnection.Close();



        }
    }











}