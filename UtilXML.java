package com.lawsbreak.kara.utilities;

import android.content.Context;
import android.util.Log;
import android.util.Xml;

import com.lawsbreak.kara.network.PacketInfo;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xmlpull.v1.XmlSerializer;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

/**
 * Created by vCode.vn on 8/17/2015.
 */
public class UtilXML {
    private static  Context context;
    public static UtilXML instance = null;

    public UtilXML(Context context) {
        this.context = context;
    }

    public static UtilXML getInstance(Context context){
        if (instance == null) {
            instance = new UtilXML(context);
        }
        return  instance;
    }

    public static PacketInfo stringGetBindingCode(){
            PacketInfo packetInfo = new PacketInfo();

            packetInfo.setHeadAttribute("fromip", "192.168.0.1");
            packetInfo.setHeadAttribute("packtype", "32");
            packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
            packetInfo.setHeadAttribute("sessionid", "1231");
            packetInfo.setHeadAttribute("version", "1");

            packetInfo.setBodyAttribute("cmdid", "E420");
           // packetInfo.setBodyAttribute("roombindingcode", Constains.roombindingcode);
           // packetInfo.setBodyAttribute("controltype", "10");
           // packetInfo.setBodyAttribute("controlvalue","2");
            return packetInfo;
    }

    public static PacketInfo stringPause(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "10");
        packetInfo.setBodyAttribute("controlvalue","1");

        return packetInfo;
    }
    public static PacketInfo stringReplay(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "10");
        packetInfo.setBodyAttribute("controlvalue","3");

        return packetInfo;
    }


    public static PacketInfo stringNext(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "10");
        packetInfo.setBodyAttribute("controlvalue","2");

        return packetInfo;
    }
    public static PacketInfo stringLip(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "10");
        packetInfo.setBodyAttribute("controlvalue","4");

        return packetInfo;
    }
    public static PacketInfo stringMute(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "20");
        packetInfo.setBodyAttribute("controlvalue","10");

        return packetInfo;
    }
    public static PacketInfo stringDrum(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "22");
        packetInfo.setBodyAttribute("controlvalue","3");

        return packetInfo;
    }
    public static PacketInfo stringClap(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "22");
        packetInfo.setBodyAttribute("controlvalue","4");

        return packetInfo;
    }
    public static PacketInfo stringThumbUp(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "22");
        packetInfo.setBodyAttribute("controlvalue","1");

        return packetInfo;
    }
    public static PacketInfo stringThumbDown(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "22");
        packetInfo.setBodyAttribute("controlvalue","2");

        return packetInfo;
    }
    public static PacketInfo stringvolumeup(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "20");
        packetInfo.setBodyAttribute("controlvalue","3");

        return packetInfo;
    }public static PacketInfo stringvolumedown(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("controltype", "20");
        packetInfo.setBodyAttribute("controlvalue","4");

        return packetInfo;
    }
    public static PacketInfo stringvolumedefualt(){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E420");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);


        return packetInfo;
    }
    public static PacketInfo stringSelectSong(String id){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("kp", "0");
        packetInfo.setBodyAttribute("controltype", "40");
        packetInfo.setBodyAttribute("controlvalue",id);

        return packetInfo;
    }
    public static PacketInfo stringPushSongTop(String id){
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E400");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setBodyAttribute("kp", "0");
        packetInfo.setBodyAttribute("controltype", "41");
        packetInfo.setBodyAttribute("controlvalue", id);

        return packetInfo;
    }
    public static PacketInfo stringChoseSong(int VolumeChose)
    {
        ConnectSharedReference.sessionID = 3251;
        PacketInfo packetInfo = new PacketInfo();

        packetInfo.setHeadAttribute("fromip","192.168.0.1");
        packetInfo.setHeadAttribute("packtype", "32");
        packetInfo.setHeadAttribute("toip", ConnectSharedReference.serverIP);
        packetInfo.setHeadAttribute("sessionid", "2387");
        packetInfo.setHeadAttribute("version", "1");

        packetInfo.setBodyAttribute("cmdid", "E402");
        packetInfo.setBodyAttribute("roombindingcode", ConnectSharedReference.roomBindingCode);
        packetInfo.setRecordsAttribute("startpos", "0");
        packetInfo.setRecordsAttribute("timestamp", "0");
        packetInfo.setRecordsAttribute("num", "20");

        return packetInfo;
    }

    public static String[] XMLParser(String XML,String Tags,String ... atrr)
    {
        String response[] = new String[atrr.length];
        XMLDOMParser parser = new XMLDOMParser();
        Document doc = parser.getDocument(XML);
        NodeList nodeList = doc.getElementsByTagName(Tags);
        for (int temp = 0; temp < nodeList.getLength(); temp++) {
            Node nNode = nodeList.item(temp);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {

                for(int i = 0; i < atrr.length; i++)
                {
                    Element eElement = (Element) nNode;
                    response[i] = eElement.getAttribute(atrr[i]);
                }

            } else {
                Log.e("Khong","Doc Doc");
            }
        }
        return response;
    }
    public static String[][] XMLParserChose(String XML)
    {

        XMLDOMParser parser = new XMLDOMParser();
        Document doc = parser.getDocument(XML);
        NodeList nodeList = doc.getElementsByTagName("record");
        String response[][] = new String[nodeList.getLength()][nodeList.getLength()];
        for (int temp = 0; temp < nodeList.getLength(); temp++) {
            Node nNode = nodeList.item(temp);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                int j = 1;
                for(int i = 0; i < nodeList.getLength(); i++)
                {

                    Element eElement = (Element) nNode;
                    response[temp][i] = eElement.getAttribute("songid");
                    response[temp][j] = eElement.getAttribute("songname");
                    j++;
                }

            } else {
                Log.e("Khong","Doc Doc");
            }
        }
        return response;
    }
}
