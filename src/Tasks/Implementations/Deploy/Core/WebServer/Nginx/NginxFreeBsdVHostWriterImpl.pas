(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NginxFreeBsdVHostWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    VirtualHostWriterIntf;

type

    (*!--------------------------------------
     * Task that creates nginx web server virtual host file
     * in FreeBsd
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNginxFreeBsdVHostWriter = class(TInterfacedObject, IVirtualHostWriter)
    private
        fTextFileCreator : ITextFileCreator;
        fApacheVer : string;
    public
        constructor create(
            const txtFileCreator : ITextFileCreator;
            const apacheVer : string = 'apache24'
        );
        procedure writeVhost(
            const serverName : string;
            const vhostTpl : string;
            const cntModifier : IContentModifier
        );
    end;

implementation

uses

    SysUtils;

    constructor TNginxFreeBsdVHostWriter.create(
        const txtFileCreator : ITextFileCreator
    );
    begin
        fTextFileCreator := txtFileCreator;
    end;

    procedure TNginxFreeBsdVHostWriter.writeVhost(
        const serverName : string;
        const vhostTpl : string;
        const cntModifier : IContentModifier);
    begin
        contentModifier.setVar('[[NGINX_LOG_DIR]]', '/var/log/nginx');
        fTextFileCreator.createTextFile(
            '/usr/local/etc/nginx/conf.d/' + serverName + '.conf',
            contentModifier.modify(vhostTpl)
        );
    end;

end.
