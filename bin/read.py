import leveldb

def main():
    db_id  = leveldb.LevelDB('./db')
    db_seq = leveldb.LevelDB('./dc')
    db_qua = leveldb.LevelDB('./de')
    #lid = []
    num = 0
    fp = open("./test.fastq", "r")
    #fp = open("./all.pacbio.fastq", "r")
    while 1:
        line = fp.readline()
        if not line:
            break
        #print str(line)
        #if (str(line)[0] == "@"):
        num += 1
        sid = 'ps' + repr(num).zfill(8)
        #lid.append(sid)
        db_id.Put(sid, line.strip('\n'))
        line = fp.readline()
        db_seq.Put(sid, line.strip('\n'))
        line = fp.readline()
        line = fp.readline()
        db_qua.Put(sid, line.strip('\n'))
    fp.close()

    adjust = "????????????????????????????????????????????????????????????????????????????????"
    c_pos = 0
    c_chr = ""
    c_seq = ""
    c_qua = ""
    t_seq = ""
    t_qua = ""

    fp = open("./test.pass", "r")
    while 1:
        line = fp.readline()
        if not line:
            break
        elif line[0] == "#":
            pass
        else:
            t = line.split("\t")
            if t[0] == c_chr:
                if c_pos > int(t[1]) - 1:
                    pass
                else:
                    c_seq += t_seq[c_pos + 1:int(t[1])]
                    c_qua += t_qua[c_pos + 1:int(t[1])] 
                    c_seq += t[4]
                    c_qua += adjust[0:len(t[4])]
                    c_pos = int(t[1]) - 1 + len(t[3]) - 1
            else:
                if c_pos:
                    c_seq += t_seq[(c_pos + 1):len(t_seq)]
                    c_qua += t_qua[(c_pos + 1):len(t_qua)]
                    #'''
                    db_seq.Put(c_chr,c_seq)
                    db_qua.Put(c_chr,c_qua)
                    #'''
                    '''
                        print $seq_hash{$c_chr}{"t"};
                        print "\n";
                        print "$c_seq\n";
                        print "\n\+\n";
                        print "$c_qua\n";
                        $ced_hash{$c_chr} += 1;
                    '''
                    #last tail;
                c_pos = 0    # a new seq begin
                c_chr = t[0]
                #print c_chr
                c_seq = ""
                c_qua = ""
                #'''
                t_seq = db_seq.Get(c_chr)
                t_qua = db_qua.Get(c_chr)
                db_seq.Delete(c_chr)
                db_qua.Delete(c_chr)
                #'''
                c_seq += t_seq[c_pos:int(t[1])]
                c_qua += t_qua[c_pos:int(t[1])]
                c_seq += t[4]; # change
                c_qua += adjust[0:len(t[4])];
                c_pos = int(t[1]) - 1 + len(t[3]) - 1;  # 0-start;
    fp.close() 
    
    c_seq += t_seq[(c_pos + 1):len(t_seq)]
    c_qua += t_qua[(c_pos + 1):len(t_qua)]
    db_seq.Put(c_chr,c_seq)
    db_qua.Put(c_chr,c_qua)

    for x in xrange(1,num+1):
        sid = 'ps' + repr(num).zfill(8)
        print db_id.Get(sid)
        print db_seq.Get(sid)
        print "+"
        print db_qua.Get(sid)

    import shutil
    shutil.rmtree('db')
    shutil.rmtree('dc')
    shutil.rmtree('de')

if __name__ == '__main__':
    main()