import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** countfrom - count number of messages from each sender. */
public class CountFrom {

    public static void main( String args[] ) throws IOException {
        TreeMap from = new TreeMap();
        BufferedReader br = new BufferedReader( new InputStreamReader( System.in ) );
        String line;
        Pattern p = Pattern.compile( "From: (.*)" );
        while ( ( line = br.readLine() ) != null ) {
            Matcher m = p.matcher( line );
            if ( m.lookingAt() ) {
                Integer current_value = (Integer) from.get( m.group( 1 ) );
                if ( current_value == null ) {
                    current_value = new Integer( 1 );
                } else {
                    current_value = new Integer( current_value.intValue() + 1 );
                }
                from.put( m.group( 1 ), current_value );
            }
        }

        for ( Iterator it = from.entrySet().iterator(); it.hasNext(); ) {
            Map.Entry e = (Map.Entry) it.next();
            System.out.println( e.getKey() + ": " + e.getValue() );
        }
    }
}
