#Licensed Materials - Property of IBM
#IBM SPSS Products: Analytics Toolkit
#(C) Copyright IBM Corp. 2012 All Rights Reserved. 
#US Government Users Restricted Rights - Use, duplication or      
#disclosure restricted by GSA ADP Schedule Contract with          
#IBM Corp.                                                        

NAMESPACE=com.ibm.spss.streams.analytics

TFILE=$NAMESPACE.tar.gz
TFILE=`readlink -f $TFILE`
                           
# Target directory specified or default?

if [ "$1" ]; then
	DEST=$1
else
	DEST=$STREAMS_TOOLKIT_INSTALL
fi

if [ "$DEST" ]; then
    DEST=`readlink -f $DEST`
else
    echo "ERROR: Missing destination directory."
    echo "    Usage: installToolkit.sh <destdir>"
    echo "        if <destdir> omitted STREAMS_TOOLKIT_INSTALL variable used"
    exit 1
fi

if [ -d "$DEST" ]; then 
   echo "    Install target directory: $DEST"
else
   echo " ERROR: Target directory does not exist: $DEST"
   echo "        No extract of the toolkit performed."
   exit 2 
fi 

cd $DEST

#  Perform the extract.

tar xfv "$TFILE"

echo ""
echo "SPSS Analytics Toolkit installed successfully to parent directory: $DEST"

exit 0
