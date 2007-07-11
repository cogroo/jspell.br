while(<>){
    s/-/\n/g;
    next if /\'/;
    print;
}
