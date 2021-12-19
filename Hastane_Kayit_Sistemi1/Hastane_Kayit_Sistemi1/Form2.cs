using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.Odbc;
using Npgsql;

namespace Hastane_Kayit_Sistemi1
{
    public partial class Form2 : Form
    {
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost;port=5432;Database=HastaKayit;user Id=postgres;password=1234");
        string hastaId = "";
        public Form2(string hasta)
        {
            string hastaid = hasta;
            hastaId = hastaid;
            InitializeComponent();


        }
        string[,] iller = new string[2, 20];
        string[,] ilceler = new string[2, 20];
        int iluzunluk = 0, ilceuzunluk = 0;
        string ilceindex = "";
        private void Form2_Load(object sender, EventArgs e)
        {
            baglanti.Open();

            string sorguIl = "SELECT * FROM ilgetir();";
            NpgsqlCommand pcmd = new NpgsqlCommand(sorguIl, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorguIl, baglanti);

            DataSet ds = new DataSet();
            da.Fill(ds);
            NpgsqlDataReader reader = pcmd.ExecuteReader();
            int j = 0;
            int plaka = 0;

            while (reader.Read())
            {


                iller[0, j] = (plaka + 1).ToString();
                iller[1, j] = reader["ad"].ToString();
                comboBox1.Items.Add(reader["ad"]);
                j++;
                plaka++;
                iluzunluk = j;
            }
            reader.Close();
            baglanti.Close();
            comboBox2.Items.Clear();

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        string ilindex = "";
        private void comboBox2_DropDown(object sender, EventArgs e)
        {
            comboBox2.Text = "";
            comboBox2.Items.Clear();
            baglanti.Open();
            string com1 = "";
            com1 = comboBox1.SelectedItem.ToString();
            Console.WriteLine(com1);
            Console.Write("hata denrtimi");
            string index = "";
            for (int i = 0; i < iluzunluk; i++)
            {
                if (iller[1, i] == com1)
                {
                    index = iller[0, i].ToString();
                    ilindex = index;
                    break;
                }
            }

            string sorguIlce = "SELECT * FROM ilcegetir(" + index + ");";
            NpgsqlCommand pcmd2 = new NpgsqlCommand(sorguIlce, baglanti);
            NpgsqlDataAdapter da2 = new NpgsqlDataAdapter(sorguIlce, baglanti);
            NpgsqlCommand pcmd3 = new NpgsqlCommand("SELECT * FROM ilcegetir2()", baglanti);

            DataSet ds2 = new DataSet();
            da2.Fill(ds2);
            NpgsqlDataReader reader1 = pcmd3.ExecuteReader();
            int j = 0;
            int ilce = 1;
            while (reader1.Read())
            {
                ilceler[0, j] = ilce.ToString();
                ilce++;
                ilceler[1, j] = reader1["ad"].ToString();
                j++;
                ilceuzunluk++;


            }
            reader1.Close();
            NpgsqlDataReader reader2 = pcmd2.ExecuteReader();

            while (reader2.Read())
            {

                comboBox2.Items.Add(reader2["ad"]);
            }

            reader2.Close();
            baglanti.Close();
        }

        private void comboBox4_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        string[,] hastaneler = new string[2, 20];

        private void comboBox4_DropDown(object sender, EventArgs e)
        {
            comboBox4.Items.Clear();
            comboBox4.Text = "";
            baglanti.Open();

            string com = "";
            string hastanekodu = "";
            com = comboBox3.SelectedItem.ToString();
            for (int i = 0; i < 20; i++)
            {
                if (com == hastaneler[1, i])
                {
                    hastanekodu = hastaneler[0, i];
                }
            }
            string sorgu = "SELECT * FROM bolumgetir(" + hastanekodu + "); ";
            NpgsqlCommand cmd = new NpgsqlCommand(sorgu, baglanti);
            NpgsqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                comboBox4.Items.Add(rdr["ad"].ToString());

            }
            rdr.Close();
            baglanti.Close();

        }
        string hastaneKodu = "";
        string docad = "";
        string docsoyad = "";
        private void comboBox5_DropDown(object sender, EventArgs e)
        {
            baglanti.Open();
            string com = "";
            string hastanekodu = "";
            com = comboBox3.SelectedItem.ToString();
            for (int i = 0; i < 20; i++)
            {
                if (com == hastaneler[1, i])
                {
                    hastanekodu = hastaneler[0, i];
                    hastaneKodu = hastanekodu;
                }
            }
            string bolum = "";
            bolum = comboBox4.SelectedItem.ToString();
            string sorgu = "SELECT * FROM doktorgetir(" + hastanekodu + " ,'" + bolum + "')";
            NpgsqlCommand cmd = new NpgsqlCommand(sorgu, baglanti);
            NpgsqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                comboBox5.Items.Add(rdr["ad"] + " " + rdr["unvani"]);
            }
            rdr.Close();
            baglanti.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            docad = comboBox5.SelectedItem.ToString();
            string[] dizi = docad.Split();

            string sorgu = "SELECT * FROM public.acilanrandevular WHERE \"rndhastane\"=" + hastaneKodu + "and \"rndbolum\"='" + comboBox4.SelectedItem.ToString() + "' and \"rnddoc\"=(select \"docid\" FROM hastaneler.doctorlar Where \"docad\"='" + dizi[0] + "'and docsoyad ='" + dizi[1] + "' and \"hastanesi\"=" + hastaneKodu + ");";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

            baglanti.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand cmd = new NpgsqlCommand("INSERT INTO public.randevularim (\"randid\",\"hastaid\") Values (@p1,@p2);", baglanti);
            cmd.Parameters.AddWithValue("@p1", int.Parse(textBox1.Text));
            cmd.Parameters.AddWithValue("@p2", int.Parse(hastaId));
            cmd.ExecuteNonQuery();
            MessageBox.Show("randevu alındı");
            baglanti.Close();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form5 frm = new Form5(hastaId);
            frm.Show();
            this.Hide();
        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form6 frm = new Form6(hastaId);
            frm.Show();
            this.Hide();
        }

        private void linkLabel3_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {


            baglanti.Open();
            string sorgu = "  SELECT \"ilacadi\" FROM public.ilaclarim WHERE \"hastaid\"=" + hastaId + ";";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView2.DataSource = ds.Tables[0];

            baglanti.Close();

        }

        private void comboBox3_DropDown(object sender, EventArgs e)
        {
            comboBox3.Text = "";
            comboBox3.Items.Clear();
            baglanti.Open();
            string com1 = "";
            com1 = comboBox2.SelectedItem.ToString();
            string index = "";
            for (int k = 0; k < ilceuzunluk; k++)
            {
                if (ilceler[1, k] == com1)
                {
                    index = iller[0, k].ToString();
                    ilceindex = index;
                    break;

                }
            }
            string sorguH = "SELECT * FROM hastaneara(" + ilindex + "," + ilceindex + ");";
            NpgsqlCommand pcmd3 = new NpgsqlCommand(sorguH, baglanti);
            NpgsqlDataReader rdr3 = pcmd3.ExecuteReader();
            while (rdr3.Read())
            {
                comboBox3.Items.Add(rdr3["ad"].ToString());
            }
            rdr3.Close();
            NpgsqlCommand pcmd = new NpgsqlCommand("SELECT * FROM hastanegetir();", baglanti);
            NpgsqlDataReader rdr = pcmd.ExecuteReader();
            int i = 0;
            while (rdr.Read())
            {
                hastaneler[0, i] = rdr["id"].ToString();
                hastaneler[1, i] = rdr["ad"].ToString();
                i++;
            }
            rdr.Close();
            baglanti.Close();
        }
    }
}
