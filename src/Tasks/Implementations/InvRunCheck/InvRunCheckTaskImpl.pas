(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit InvRunCheckTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    RunCheckTaskImpl;

type

    (*!--------------------------------------
     * Task that run other task only if
     * we are not in project directory that is generated
     * by Fano CLI tools. This is inverse of TRunCheckTask
     *------------------------------------------
     * This is to protect accidentally creating project
     * inside Fano-CLI generated project directory
     * structure.
     *--------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TInvRunCheckTask = class(TRunCheckTask)
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils;

    function TInvRunCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if (not inFanoCliGeneratedProjectDir(getCurrentDir() + DirectorySeparator)) then
        begin
            actualTask.run(opt, longOpt);
        end else
        begin
            writeln('It looks like current directory was generated by Fano CLI.');
            writeln('Run with --help option to view available task.');
        end;
        result := self;
    end;
end.
